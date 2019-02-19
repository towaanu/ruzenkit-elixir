defmodule RuzenkitWeb.Graphql.Types.Addresses do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :address do
    field :id, non_null(:id)
    field :last_name, non_null(:string)
    field :first_name, non_null(:string)
    field :street, non_null(:string)
    field :city, non_null(:string)
    field :zip_code, non_null(:string)
    field :building, :string
    field :floor, :string
    field :place, :string
    field :extra_info, :string
    field :country, non_null(:country), resolve: dataloader(:db)
  end

  object :country do
    field :id, non_null(:id)
    field :local_name, non_null(:string)
    field :english_name, non_null(:string)
    field :short_iso_code, non_null(:string)
    field :long_iso_code, non_null(:string)
  end

  input_object :address_input do
    field :last_name, non_null(:string)
    field :first_name, non_null(:string)
    field :street, non_null(:string)
    field :city, non_null(:string)
    field :zip_code, non_null(:string)
    field :country_id, non_null(:id)
    field :building, :string
    field :floor, :string
    field :place, :string
    field :extra_info, :string
  end

  input_object :country_input do
    field :local_name, non_null(:string)
    field :english_name, non_null(:string)
    field :short_iso_code, non_null(:string)
    field :long_iso_code, non_null(:string)
  end



end
