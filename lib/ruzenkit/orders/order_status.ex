defmodule Ruzenkit.Orders.OrderStatus do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Orders.Order

  schema "order_status" do
    field :label, :string
    has_many :orders, Order

    timestamps()
  end

  @doc false
  def changeset(order_status, attrs) do
    order_status
    |> cast(attrs, [:label])
    |> update_change(:label, &String.downcase/1)
    |> validate_required([:label])
    |> unique_constraint(:label)
  end
end
