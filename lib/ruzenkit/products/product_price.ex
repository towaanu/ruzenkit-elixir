defmodule Ruzenkit.Products.ProductPrice do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Money.Currency

  schema "product_prices" do
    field :amount, :decimal, precision: 12, scale: 2
    belongs_to :currency, Currency

    timestamps()
  end

  @doc false
  def changeset(product_price, attrs) do
    product_price
    |> cast(attrs, [:amount, :currency_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_required([:amount, :currency_id])
    |> foreign_key_constraint(:currency_id)
  end
end
