defmodule RuzenkitWeb.Graphql.Types.Stocks do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :stock do
    field :id, non_null(:id)
    field :quantity, :integer
    field :product, :product, resolve: dataloader(:db)
  end

  input_object :stock_input do
    field :quantity, :integer
    field :product_id, non_null(:id)
  end


end
