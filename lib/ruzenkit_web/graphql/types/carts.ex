defmodule RuzenkitWeb.Graphql.Types.Carts do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ruzenkit.Carts

  object :cart do
    field :id, non_null(:id)
    field :user, :user, resolve: dataloader(:db)
    field :cart_items, list_of(:cart_item), resolve: dataloader(:db)

    field :total_price, :decimal do
      resolve(fn cart, _, _ ->
        {:ok, Carts.total_price_for_cart(cart)}
      end)
    end
  end

  object :cart_item do
    field :id, non_null(:id)
    field :quantity, non_null(:integer)
    field :cart, :cart, resolve: dataloader(:db)
    field :product, :product, resolve: dataloader(:db)

    field :total_price, :decimal do
      resolve(fn cart_item, _, _ ->
        {:ok, Carts.total_price_for_cart_item(cart_item)}
      end)
    end
  end

  input_object :cart_input do
    # field :user_id, :id
  end

  input_object :cart_item_input do
    field :quantity, non_null(:integer)
    field :cart_id, :id
    field :product_id, :id
  end

  input_object :product_option_input do
    field :option_id, non_null(:id)
    field :option_item_id, non_null(:id)
  end
end
