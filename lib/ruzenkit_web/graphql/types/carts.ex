defmodule RuzenkitWeb.Graphql.Types.Carts do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ruzenkit.Carts

  object :cart do
    field :id, non_null(:id)
    field :user, :user, resolve: dataloader(:db)
    field :cart_items, list_of(:cart_item), resolve: dataloader(:db)
    field :cart_shipping_information, :cart_shipping_information, resolve: dataloader(:db)
    field :email, :string

    field :total_price, :decimal do
      resolve(fn cart, _, _ ->
        {:ok, Carts.total_price_for_cart(cart)}
      end)
    end
  end

  object :cart_shipping_information do
    field :id, non_null(:id)
    field :cart, :cart, resolve: dataloader(:db)
    field :shipping_option, :shipping_option, resolve: dataloader(:db)
    field :country, :country, resolve: dataloader(:db)

    field :building, :string
    field :city, :string
    field :extra_info, :string
    field :first_name, :string
    field :floor, :string
    field :last_name, :string
    field :place, :string
    field :zip_code, :string
    field :street, :string
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
    field :id, :id
    field :quantity, non_null(:integer)
    field :cart_id, :id
    field :product_id, :id
  end

  input_object :cart_shipping_information_address_input do
    field :id, :id
    field :country_id, :id

    field :building, :string
    field :city, :string
    field :extra_info, :string
    field :first_name, :string
    field :floor, :string
    field :last_name, :string
    field :place, :string
    field :zip_code, :string
    field :street, :string
  end

  input_object :product_option_input do
    field :option_id, non_null(:id)
    field :option_item_id, non_null(:id)
  end
end
