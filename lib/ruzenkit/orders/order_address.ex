defmodule Ruzenkit.Orders.OrderAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Orders.Order


  schema "order_addresses" do
    field :building, :string
    field :city, :string
    field :extra_info, :string
    field :first_name, :string
    field :floor, :string
    field :last_name, :string
    field :place, :string
    field :zip_code, :string
    field :street, :string

    field :country, :string

    has_one :order, Order

    timestamps()
  end

  @doc false
  def changeset(order_address, attrs) do
    order_address
    |> cast(attrs, [:first_name, :last_name, :city, :zip_code, :building, :floor, :place, :extra_info, :street, :country])
    |> validate_required([:first_name, :last_name, :city, :zip_code, :street, :country])
  end
end
