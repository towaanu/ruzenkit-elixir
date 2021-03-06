defmodule Ruzenkit.Shippings.ShippingOption do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Shippings.ShippingCarrier
  alias Ruzenkit.Addresses.Country
  alias Ruzenkit.Money.Price

  schema "shipping_options" do
    field :description, :string
    field :name, :string
    field :shipping_hour_time, :float
    belongs_to :shipping_carrier, ShippingCarrier
    belongs_to :price, Price, on_replace: :update
    many_to_many :countries, Country, join_through: "shipping_options_countries"

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(shipping_option, attrs) do
    shipping_option
    |> cast(attrs, [:name, :description, :shipping_hour_time, :shipping_carrier_id])
    |> cast_assoc(:price)
    |> validate_required([:name])
  end
end
