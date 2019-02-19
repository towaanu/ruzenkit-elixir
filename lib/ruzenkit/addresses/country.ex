defmodule Ruzenkit.Addresses.Country do
  use Ecto.Schema
  import Ecto.Changeset

  import Ruzenkit.Utils.StringUtils, only: [trim_and_downcase: 1, trim_and_upcase: 1]

  schema "countries" do
    field :english_name, :string
    field :local_name, :string
    field :long_iso_code, :string
    field :short_iso_code, :string

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:english_name, :local_name, :short_iso_code, :long_iso_code])
    |> validate_required([:english_name, :local_name, :short_iso_code, :long_iso_code])
    |> update_change(:english_name, &trim_and_downcase/1)
    |> update_change(:short_iso_code, &trim_and_upcase/1)
    |> update_change(:long_iso_code, &trim_and_upcase/1)
    |> unique_constraint(:short_iso_code)
    |> unique_constraint(:long_iso_code)
  end
end
