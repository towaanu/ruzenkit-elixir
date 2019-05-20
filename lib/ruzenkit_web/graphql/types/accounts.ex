defmodule RuzenkitWeb.Graphql.Types.Accounts do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user do
    field :id, non_null(:id)
    field :credential, non_null(:credential), resolve: dataloader(:db)
    field :profile, non_null(:profile), resolve: dataloader(:db)
    field :orders, list_of(:order), resolve: dataloader(:db)
  end

  object :profile do
    field :id, non_null(:id)
    field :first_name, :string
    field :last_name, :string
    field :email, non_null(:string)
    field :profile_addresses, list_of(:profile_address), resolve: dataloader(:db)
  end

  object :credential do
    field :id, non_null(:id)
    # field :password_hash, non_null(:string)
  end

  object :profile_address do
    field :id, non_null(:id)
    field :is_default, :boolean
    field :address, non_null(:address), resolve: dataloader(:db)
  end

  input_object :user_input do
    field :credential, non_null(:credential_input)
    field :profile, non_null(:profile_input)
  end

  input_object :profile_input do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :profile_addresses, list_of(:profile_address_input)
  end

  input_object :credential_input do
    field :password, non_null(:string)
  end

  input_object :profile_address_input do
    field :id, :id
    field :is_default, :boolean
    field :address, non_null(:address_input)
    # field :profile_id, non_null(:id)
  end

end
