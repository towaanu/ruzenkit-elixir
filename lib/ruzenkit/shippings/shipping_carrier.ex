defmodule Ruzenkit.Shippings.ShippingCarrier do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Shippings.ShippingOption


  schema "shipping_carriers" do
    field :name, :string
    has_many :shipping_options, ShippingOption

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(shipping_carrier, attrs) do
    shipping_carrier
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
