defmodule Ruzenkit.Carts.CartShippingInformation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Shippings.ShippingOption
  alias Ruzenkit.Addresses.Country
  alias Ruzenkit.Carts.Cart

  schema "cart_shipping_information" do
    field :building, :string
    field :city, :string
    field :extra_info, :string
    field :first_name, :string
    field :floor, :string
    field :last_name, :string
    field :place, :string
    field :zip_code, :string
    field :street, :string

    belongs_to :country, Country
    belongs_to :shipping_option, ShippingOption
    belongs_to :cart, Cart

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cart_shipping_information, attrs) do
    cart_shipping_information
    |> cast(attrs, [
      :first_name,
      :last_name,
      :city,
      :zip_code,
      :building,
      :floor,
      :place,
      :extra_info,
      :street,
      :country_id,
      :shipping_option_id
    ])
    |> validate_required([:first_name, :last_name, :city, :zip_code, :street, :country_id])
    |> foreign_key_constraint(:country_id)
    |> foreign_key_constraint(:shipping_option_id)
  end
end
