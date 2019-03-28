defmodule Ruzenkit.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Accounts.User
  alias Ruzenkit.Orders.OrderItem
  alias Ruzenkit.Orders.OrderStatus
  alias Ruzenkit.Orders.OrderAddress

  schema "orders" do
    field :total, :decimal, precision: 12, scale: 2
    field :comment, :string
    belongs_to :user, User
    belongs_to :order_status, OrderStatus
    has_many :order_items, OrderItem
    has_one :order_address, OrderAddress

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total, :order_status_id, :user_id])
    |> cast_assoc(:order_address, with: &Ruzenkit.Orders.OrderAddress.changeset/2)
    |> validate_number(:total, greater_than_or_equal_to: 0)
    |> validate_required([:total, :order_status_id])
    |> foreign_key_constraint(:order_status_id)
    |> foreign_key_constraint(:user_id)
  end

  def update_changeset(order, attrs) do
    order
    |> cast(attrs, [:comment, :order_status_id])
    |> foreign_key_constraint(:order_status_id)
  end

  def change_status_changeset(order, attrs) do
    order
    |> cast(attrs, [:order_status_id])
    |> foreign_key_constraint(:order_status_id)
  end
end
