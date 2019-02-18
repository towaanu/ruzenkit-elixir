defmodule Ruzenkit.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Accounts.User
  alias Ruzenkit.Orders.OrderItem
  alias Ruzenkit.Orders.OrderStatus

  schema "orders" do
    field :total, :decimal
    belongs_to :user, User
    belongs_to :order_status, OrderStatus
    has_many :order_items, OrderItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total])
    |> validate_number(:total, greater_than_or_equal_to: 0)
    |> validate_required([:total])
  end
end
