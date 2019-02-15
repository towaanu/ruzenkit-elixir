defmodule Ruzenkit.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Accounts.User
  alias Ruzenkit.Carts.CartItem

  schema "carts" do
    belongs_to :user, User
    has_many :cart_items, CartItem

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
