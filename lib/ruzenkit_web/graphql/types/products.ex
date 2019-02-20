defmodule RuzenkitWeb.Graphql.Types.Products do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :product_price do
    field :id, non_null(:id)
    field :amount, :decimal
    field :currency, :currency, resolve: dataloader(:db)
  end

  object :product do
    field :id, non_null(:id)
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :price, :product_price, resolve: dataloader(:db)
    field :parent_product, :product, resolve: dataloader(:db)
    field :child_products, list_of(:product), resolve: dataloader(:db)
    field :configurable_options, list_of(:configurable_option), resolve: dataloader(:db)
    field :stock, :stock, resolve: dataloader(:db)
  end

  object :configurable_option do
    field :id, non_null(:id)
    field :label, non_null(:string)
    field :configurable_item_options, list_of(non_null(:configurable_item_option)), resolve: dataloader(:db)
    field :products, list_of(:product), resolve: dataloader(:db)
  end

  object :configurable_item_option do
    field :id, non_null(:id)
    field :label, :string
    field :short_label, :string
    field :configurable_option, non_null(:configurable_option), resolve: dataloader(:db)
  end

  input_object :product_price_input do
    field :amount, :decimal
    field :currency_id, :id
  end

  input_object :product_input do
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :price, :product_price_input
    field :parent_product_id, :id
  end

  input_object :configurable_item_option_input do
    field :label, :string
    field :short_label, :string
    field :configurable_option_id, :id
  end

end
