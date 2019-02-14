defmodule RuzenkitWeb.Graphql.Types.Accounts do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :credential, non_null(:credential)
  end

  object :credential do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :password_hash, non_null(:string)
  end


  input_object :user_input do
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :credential, non_null(:credential_input)
  end

  input_object :credential_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

end
