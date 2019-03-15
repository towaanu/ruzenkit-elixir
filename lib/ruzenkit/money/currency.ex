defmodule Ruzenkit.Money.Currency do
  use Ecto.Schema
  import Ecto.Changeset


  schema "currencies" do
    field :code, :string
    field :name, :string
    field :sign, :string

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :sign, :code])
    |> validate_required([:name, :sign, :code])
    |>validate_length(:sign, max: 10)
    |>validate_length(:code, max: 10)
    |> unique_constraint(:code)
  end
end
