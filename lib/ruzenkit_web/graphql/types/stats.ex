defmodule RuzenkitWeb.Graphql.Types.Stats do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]


  object :stats_order_item do
    field :id, non_null(:id)
    field :quantity, :integer
    field :price_amount, :decimal
    field :price_currency_code, :string
    field :price_currency_sign, :string
    field :vat_rate, :float
    field :vat_label, :string
    field :vat_country_short_iso_code, :string
    field :vat_country_long_iso_code, :string
    field :vat_country_english_name, :string
    field :vat_total_amount, :decimal
    field :order, :order, resolve: dataloader(:db)
    field :product, :product, resolve: dataloader(:db)
  end


  object :stats_order do
    field :id, non_null(:id)
    field :total, :decimal
    field :vat_total_amount, :decimal
    field :inserted_at, :datetime
    field :updated_at, :datetime

    field :user, :user, resolve: dataloader(:db)
    field :order_status, :order_status, resolve: dataloader(:db)
    field :order_items, list_of(:stats_order_item)
    field :order_address, :order_address, resolve: dataloader(:db)
  end

  input_object :date_range_input do
    field :label, non_null(:string)
    field :is_default, :boolean

    field :start_iso_date, non_null(:string)
    field :end_iso_date, non_null(:string)
  end

end
