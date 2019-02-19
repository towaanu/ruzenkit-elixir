defmodule RuzenkitWeb.Graphql.Types.Shippings do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :shipping_carrier do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :shipping_options, list_of(:shipping_option), resolve: dataloader(:db)
  end

  object :shipping_option do
    field :id, non_null(:id)
    field :name, :string
    field :description, :string
    field :shipping_hour_time, :float
    field :shipping_carrier, :shipping_carrier, resolve: dataloader(:db)
    field :countries, list_of(:country), resolve: dataloader(:db)
  end

  input_object :shipping_option_input do
    field :name, :string
    field :description, :string
    field :shipping_hour_time, :float
    field :shipping_carrier_id, non_null(:id)
    field :country_ids, list_of(non_null(:id))
  end

  input_object :shipping_carrier_input do
    field :name, non_null(:string)
  end



end
