defmodule RuzenkitWeb.Graphql.Types.Money do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :currency do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :code, non_null(:string)
    field :sign, non_null(:string)
  end

  object :price do
    field :id, non_null(:id)
    field :amount, :decimal
    field :currency, :currency, resolve: dataloader(:db)
  end

  input_object :currency_input do
    field :name, non_null(:string)
    field :code, non_null(:string)
    field :sign, non_null(:string)
  end

  input_object :price_input do
    field :amount, non_null(:decimal)
    field :currency_id, non_null(:id)
  end

end
