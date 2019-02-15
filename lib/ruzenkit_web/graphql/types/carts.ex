defmodule RuzenkitWeb.Graphql.Types.Carts do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias RuzenkitWeb.Graphql.Types

  object :cart do
    field :id, non_null(:id)
    field :user, :user, resolve: dataloader(:db)
    field :cart_items, list_of(:cart_item), resolve: dataloader(:db)
  end

  object :cart_item do
    field :id, non_null(:id)
    field :quantity, non_null(:integer)
    field :cart, :cart, resolve: dataloader(:db)
    field :product, :product, resolve: dataloader(:db)
  end

  input_object :cart_input do
    field :user_id, :id
  end

  input_object :cart_item_input do
    field :quantity, non_null(:integer)
    field :cart_id, :id
    field :product_id, :id
  end
end
