defmodule RuzenkitWeb.Schema do
  use Absinthe.Schema

  alias RuzenkitWeb.ProductsResolver

  object :product do
    field :id, non_null(:id)
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
  end

  query do
    # this is the query entry point to our app
    field :products, list_of(:product) do
      resolve &ProductsResolver.products/3
    end
  end
end
