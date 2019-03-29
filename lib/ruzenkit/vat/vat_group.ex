defmodule Ruzenkit.Vat.VatGroup do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Addresses.Country

  schema "vat_groups" do
    field :label, :string
    field :rate, :float, default: 0.0
    belongs_to :country, Country

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(vat_group, attrs) do
    vat_group
    |> cast(attrs, [:rate, :label, :country_id])
    |> validate_required([:rate])
    |> foreign_key_constraint(:country_id)
  end

end
