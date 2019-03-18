defmodule Ruzenkit.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Orders.Order
  alias Ruzenkit.Products.Product

  schema "order_items" do
    field :quantity, :integer
    field :price_amount, :decimal, precision: 12, scale: 2
    field :price_currency_code, :string
    field :price_currency_sign, :string
    field :vat_rate, :float, default: 0.0
    field :vat_label, :string
    field :vat_country_short_iso_code, :string
    field :vat_country_long_iso_code, :string
    field :vat_country_english_name, :string

    belongs_to :order, Order
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [
      :quantity,
      :price_amount,
      :price_currency_code,
      :price_currency_sign,
      :product_id,
      :vat_rate,
      :vat_label,
      :vat_country_short_iso_code,
      :vat_country_long_iso_code,
      :vat_country_english_name
    ])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_required([
      :quantity,
      :price_amount,
      :price_currency_code,
      :price_currency_sign,
      :vat_country_short_iso_code,
      :vat_country_long_iso_code,
      :vat_country_english_name
    ])
    |> foreign_key_constraint(:product_id)
  end
end
