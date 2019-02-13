defmodule RuzenkitWeb.Graphql.Schema do
  use Absinthe.Schema

  alias RuzenkitWeb.Graphql.ProductsResolver
  alias RuzenkitWeb.Graphql.Types

  import_types Types.Products

  query do
    # this is the query entry point to our app
    field :products, list_of(:product) do
      resolve &ProductsResolver.list_products/3
    end

    field :product, :product do
      arg :id, non_null(:id)

      resolve &ProductsResolver.get_product/3
    end

  end

  mutation do
    field :create_product, :product do
      arg :sku, non_null(:string)
      arg :name, non_null(:string)
      arg :description, :string

      resolve &ProductsResolver.create_product/3
    end
  end

end
