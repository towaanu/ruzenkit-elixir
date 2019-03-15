defmodule RuzenkitWeb.Graphql.Types.Vat do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :vat_group do
    field :id, non_null(:id)
    field :rate, :float
    field :label, :string
    field :country, :country, resolve: dataloader(:db)
  end

  input_object :vat_group_input do
    field :rate, :float
    field :label, :string
    field :country_id, :id
  end

end
