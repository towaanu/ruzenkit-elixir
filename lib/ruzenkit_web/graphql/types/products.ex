defmodule RuzenkitWeb.Graphql.Types.Products do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :product do
    field :id, non_null(:id)
    field :sku, non_null(:string)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :configurable_options, list_of(:configurable_option), resolve: dataloader(:db)
  end

  object :configurable_option do
    field :id, non_null(:id)
    field :label, non_null(:string)
    field :products, list_of(:product), resolve: dataloader(:db)
  end

end
