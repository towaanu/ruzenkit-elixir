defmodule Ruzenkit.Orders.OrderStatus do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Orders.Order

  import Ruzenkit.Utils.StringUtils, only: [trim_and_downcase: 1]

  schema "order_status" do
    field :label, :string
    field :is_default, :boolean, default: false
    has_many :orders, Order

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(order_status, attrs) do
    order_status
    |> cast(attrs, [:label, :is_default])
    |> update_change(:label, &trim_and_downcase/1)
    |> validate_required([:label])
    |> unique_constraint(:label)
  end
end
