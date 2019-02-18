defmodule Ruzenkit.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Orders.Order
  alias Ruzenkit.Products.Product


  schema "order_items" do
    field :quantity, :integer
    belongs_to :order, Order
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_required([:quantity])
  end
end
