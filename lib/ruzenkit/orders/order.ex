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
    field :shipping_number, :string
    field :email, :string
    belongs_to :user, User
    belongs_to :order_status, OrderStatus
    has_many :order_items, OrderItem
    has_one :order_address, OrderAddress

    timestamps(type: :utc_datetime)
  end


  defp is_email_or_user?(user_id, email) do
    # user_id != nil || email |> to_string() |> String.trim() != ""
    user_id || email |> to_string() |> String.trim() != ""
  end

  defp validate_email_or_user(changeset) do
    case changeset.valid? do
      true ->
        user_id = get_field(changeset, :user_id)
        email = get_field(changeset, :email)

        case is_email_or_user?(user_id, email) do
          true -> changeset
          false -> add_error(changeset, :email, "need an email or user")
        end

      _ -> changeset
    end
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total, :order_status_id, :user_id, :email])
    |> cast_assoc(:order_address, with: &Ruzenkit.Orders.OrderAddress.changeset/2)
    |> validate_number(:total, greater_than_or_equal_to: 0)
    |> validate_email_or_user()
    |> validate_format(:email, ~r/@/)
    |> validate_required([:total, :order_status_id])
    |> foreign_key_constraint(:order_status_id)
    |> foreign_key_constraint(:user_id)
  end

  def update_changeset(order, attrs) do
    order
    |> cast(attrs, [:comment, :order_status_id, :shipping_number])
    |> foreign_key_constraint(:order_status_id)
  end

  def change_status_changeset(order, attrs) do
    order
    |> cast(attrs, [:order_status_id])
    |> foreign_key_constraint(:order_status_id)
  end
end
