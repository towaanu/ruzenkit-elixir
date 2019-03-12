defmodule Ruzenkit.Stocks.StockChange do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Stocks.Stock

  schema "stock_changes" do
    belongs_to :stock, Stock

    field :operation, :integer
    field :new_quantity, :integer
    field :label, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:operation, :new_quantity, :label, :stock_id])
    |> validate_required([:operation, :new_quantity, :stock_id])
  end
end
