defmodule RuzenkitWeb.Graphql.Types.Products do
  use Absinthe.Schema.Notation

  object :product do
    field :id, non_null(:id)
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
  end

  object :configurable_option do
    field :id, non_null(:id)
    field :label, non_null(:string)
  end

end
