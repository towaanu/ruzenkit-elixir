defmodule Ruzenkit.Stocks.Stock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Products.Product
  alias Ruzenkit.Stocks.StockChange

  schema "stocks" do
    field :quantity, :integer, default: 0
    belongs_to :product, Product
    has_many :stock_changes, StockChange

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:quantity, :product_id])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_required([:quantity, :product_id])
  end
end
