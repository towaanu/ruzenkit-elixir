defmodule Ruzenkit.Shippings.ShippingOption do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Shippings.ShippingCarrier
  alias Ruzenkit.Addresses.Country

  schema "shipping_options" do
    field :description, :string
    field :name, :string
    field :shipping_hour_time, :float
    belongs_to :shipping_carrier, ShippingCarrier
    many_to_many :countries, Country, join_through: "shipping_options_countries"

    timestamps()
  end

  @doc false
  def changeset(shipping_option, attrs) do
    shipping_option
    |> cast(attrs, [:name, :description, :shipping_hour_time, :shipping_carrier_id])
    |> validate_required([:name])
  end
end
