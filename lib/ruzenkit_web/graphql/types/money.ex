defmodule RuzenkitWeb.Graphql.Types.Money do
  use Absinthe.Schema.Notation

  object :currency do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :code, non_null(:string)
    field :sign, non_null(:string)
  end

  input_object :currency_input do
    field :name, non_null(:string)
    field :code, non_null(:string)
    field :sign, non_null(:string)
  end
end
