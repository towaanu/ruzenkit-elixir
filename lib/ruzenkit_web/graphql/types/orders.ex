defmodule RuzenkitWeb.Graphql.Types.Orders do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :order_status do
    field :id, non_null(:id)
    field :label, non_null(:string)
  end

  object :order_item do
    field :id, non_null(:id)
    field :quantity, :integer
    field :price_amount, :decimal
    field :price_currency_code, :string
    field :price_currency_sign, :string
    field :order, :order, resolve: dataloader(:db)
    field :product, :product, resolve: dataloader(:db)
  end

  object :order_address do
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

    field :order, :order, resolve: dataloader(:db)
  end

  object :order do
    field :id, non_null(:id)
    field :total, :decimal
    field :user, :user, resolve: dataloader(:db)
    field :order_status, :order_status, resolve: dataloader(:db)
    field :order_items, list_of(:order_item), resolve: dataloader(:db)
    field :order_address, :order_address, resolve: dataloader(:db)
  end

  input_object :order_status_input do
    field :label, non_null(:string)
  end

  input_object :order_address_input do
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
  end
end
