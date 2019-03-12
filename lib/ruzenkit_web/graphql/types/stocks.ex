defmodule RuzenkitWeb.Graphql.Types.Stocks do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :stock_change do
    field :id, non_null(:id)
    field :new_quantity, :integer
    field :operation, :integer
    field :label, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :stock, :stock, resolve: dataloader(:db)
  end

  object :stock do
    field :id, non_null(:id)
    field :quantity, :integer
    field :stock_changes, list_of(:stock_change), resolve: dataloader(:db)
    field :product, :product, resolve: dataloader(:db)
  end

  input_object :stock_input do
    field :quantity, :integer
    field :product_id, :id
  end

  input_object :update_stock_input do
    # field :stock_id, non_null(:id)
    field :operation, :integer
    field :label, :string
  end


end
