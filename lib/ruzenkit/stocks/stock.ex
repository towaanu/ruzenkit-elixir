defmodule Ruzenkit.Stocks.Stock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Products.Product

  schema "stocks" do
    field :quantity, :integer, default: 0
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
