defmodule Ruzenkit.Carts.CartItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Carts.Cart
  alias Ruzenkit.Products.Product


  schema "cart_items" do
    field :quantity, :integer
    belongs_to :cart, Cart
    belongs_to :product, Product

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:cart_id, :product_id, :quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_required([:cart_id, :product_id])
  end
end
