defmodule RuzenkitWeb.Graphql.Types.Accounts do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
  end


  input_object :user_input do
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
  end

end
