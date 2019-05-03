defmodule Ruzenkit.Money.Price do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Money.Currency

  schema "prices" do
    field :amount, :decimal, precision: 12, scale: 2
    belongs_to :currency, Currency

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:amount, :currency_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_required([:amount, :currency_id])
    |> foreign_key_constraint(:currency_id)
  end
end
