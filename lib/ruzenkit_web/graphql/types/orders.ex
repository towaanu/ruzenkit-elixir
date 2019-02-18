defmodule RuzenkitWeb.Graphql.Types.Orders do
  use Absinthe.Schema.Notation

  object :order_status do
    field :id, non_null(:id)
    field :label, non_null(:string)
  end

  input_object :order_status_input do
    field :label, non_null(:string)
  end
end
