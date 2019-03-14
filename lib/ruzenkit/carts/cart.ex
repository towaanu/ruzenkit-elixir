defmodule Ruzenkit.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Accounts.User
  alias Ruzenkit.Carts.CartItem
  alias Ruzenkit.Carts.Cart

  schema "carts" do
    belongs_to :user, User
    has_many :cart_items, CartItem

    field :total_price, :decimal, virtual: true

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:user_id])
    |> validate_required([])
    |> foreign_key_constraint(:user_id)
  end

  def populate_total_price(%Cart{cart_items: cart_items} = cart) do
    total_price =
      cart_items
      |> Enum.map(&%{price_amount: &1.product.price.amount, quantity: &1.quantity})
      |> Enum.map(&Decimal.mult(&1.price_amount, &1.quantity))
      |> Enum.reduce(Decimal.new(0), &Decimal.add/2)

      %{cart | total_price: total_price}
  end
end
