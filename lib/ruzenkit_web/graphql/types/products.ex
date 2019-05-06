defmodule RuzenkitWeb.Graphql.Types.Products do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ruzenkit.Products

  object :product_price do
    field :id, non_null(:id)
    field :amount, :decimal
    field :currency, :currency, resolve: dataloader(:db)
  end

  object :parent_product do
    field :id, non_null(:id)
    field :product, non_null(:product), resolve: dataloader(:db)
    field :configurable_options, list_of(:configurable_option), resolve: dataloader(:db)
    field :child_products, list_of(:child_product), resolve: dataloader(:db)
  end

  object :child_product do
    field :id, non_null(:id)
    field :product, non_null(:product), resolve: dataloader(:db)
    field :parent_product, :parent_product, resolve: dataloader(:db)
    field :configurable_item_options, list_of(:configurable_item_option), resolve: dataloader(:db)
  end

  object :product do
    field :id, non_null(:id)
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :ui_color, :string
    field :ui_color_secondary, :string

    field :picture_url, :string,
      resolve: fn product, _info, _ ->
        {:ok, Products.get_product_picture_url(product)}
      end

    field :price, :product_price, resolve: dataloader(:db)
    field :parent_product, :parent_product, resolve: dataloader(:db)
    field :child_product, :child_product, resolve: dataloader(:db)

    # field :child_products, list_of(:product), resolve: dataloader(:db)
    # field :configurable_options, list_of(:configurable_option), resolve: dataloader(:db)
    field :stock, :stock, resolve: dataloader(:db)
    field :vat_group, :vat_group, resolve: dataloader(:db)
  end

  object :configurable_option do
    field :id, non_null(:id)
    field :label, non_null(:string)

    field :configurable_item_options, list_of(non_null(:configurable_item_option)),
      resolve: dataloader(:db)

    field :products, list_of(:product), resolve: dataloader(:db)
  end

  object :configurable_item_option do
    field :id, non_null(:id)
    field :label, :string
    field :short_label, :string
    field :display_order, :integer
    field :configurable_option, non_null(:configurable_option), resolve: dataloader(:db)
  end

  input_object :parent_product_input do
    # field :product, non_null(:product), resolve: dataloader(:db)
    field :id, :id
    field :configurable_option_ids, list_of(:id)
    # field :child_products, list_of(:child_product_input)
  end

  input_object :child_product_input do
    # field :product, non_null(:product), resolve: dataloader(:db)
    # field :parent_product, non_null(:parent_product), resolve: dataloader(:db)
    field :id, :id
    field :parent_product_id, non_null(:id)
    field :configurable_item_option_ids, list_of(:id)
  end

  input_object :product_price_input do
    field :amount, :decimal
    field :currency_id, :id
  end

  input_object :product_input do
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :ui_color, :string
    field :ui_color_secondary, :string
    field :picture, :upload
    field :parent_product, :parent_product_input
    field :child_product, :child_product_input
    field :price, :product_price_input
    field :vat_group_id, :id
    field :stock, :stock_input
  end

  input_object :configurable_option_input do
    field :label, non_null(:string)

    # field :configurable_item_options, list_of(non_null(:configurable_item_option)), resolve: dataloader(:db)
    # field :products, list_of(:product), resolve: dataloader(:db)
  end

  input_object :configurable_item_option_input do
    field :label, :string
    field :short_label, :string
    field :display_order, :integer
    field :configurable_option_id, :id
  end
end
