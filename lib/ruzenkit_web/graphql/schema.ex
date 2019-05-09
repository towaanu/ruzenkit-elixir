defmodule RuzenkitWeb.Graphql.Schema do
  use Absinthe.Schema

  alias RuzenkitWeb.Graphql.ProductsResolver
  alias RuzenkitWeb.Graphql.AccountsResolver
  alias RuzenkitWeb.Graphql.CartsResolver
  alias RuzenkitWeb.Graphql.OrdersResolver
  alias RuzenkitWeb.Graphql.MoneyResolver
  alias RuzenkitWeb.Graphql.AddressesResolver
  alias RuzenkitWeb.Graphql.ShippingsResolver
  alias RuzenkitWeb.Graphql.VatResolver
  alias RuzenkitWeb.Graphql.StocksResolver
  alias RuzenkitWeb.Graphql.StatsResolver

  alias RuzenkitWeb.Graphql.Types
  alias Ruzenkit.EctoDataloader

  import_types Absinthe.Plug.Types
  import_types(Absinthe.Type.Custom)
  import_types(Types.Money)
  import_types(Types.Products)
  import_types(Types.Accounts)
  import_types(Types.Carts)
  import_types(Types.Orders)
  import_types(Types.Addresses)
  import_types(Types.Shippings)
  import_types(Types.Stocks)
  import_types(Types.Vat)
  import_types(Types.Stats)

  def context(ctx) do
    loader =
      Dataloader.new()
      # data from database with ecto
      |> Dataloader.add_source(:db, EctoDataloader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    # this is the query entry point to our app
    field :products, list_of(:product) do
      resolve(&ProductsResolver.list_products/3)
    end

    field :root_products, list_of(:product) do
      resolve(&ProductsResolver.list_root_products/3)
    end

    field :parent_products, list_of(:parent_product) do
      resolve(&ProductsResolver.list_parent_products/3)
    end

    field :parent_product, :parent_product do
      arg(:id, non_null(:id))

      resolve(&ProductsResolver.get_parent_product/3)
    end

    field :product, :product do
      arg :id, :id
      arg :sku, :string

      resolve(&ProductsResolver.get_product/3)
    end

    field :configurable_options, list_of(:configurable_option) do
      resolve(&ProductsResolver.list_configurable_options/3)
    end

    field :configurable_option, :configurable_option do
      arg(:id, non_null(:id))

      resolve(&ProductsResolver.get_configurable_option/3)
    end

    field :configurable_item_options, list_of(:configurable_item_option) do
      arg(:configurable_option_id, non_null(:id))

      resolve(&ProductsResolver.get_configurable_item_options/3)
    end

    field :configurable_item_option, :configurable_item_option do
      arg(:id, non_null(:id))

      resolve(&ProductsResolver.get_configurable_item_option/3)
    end

    field :users, list_of(:user) do
      resolve(&AccountsResolver.list_users/3)
    end

    field :user, non_null(:user) do
      arg(:id, non_null(:id))

      resolve(&AccountsResolver.get_user/3)
    end

    field :me, :string do
      resolve(&AccountsResolver.me/3)
    end

    field :cart, :cart do
      arg(:id, non_null(:id))

      resolve(&CartsResolver.get_cart/3)
    end

    field :find_shipping_options_for_cart, list_of(:shipping_option) do
      arg :cart_id, non_null(:id)

      resolve &CartsResolver.find_shipping_options_for_cart/3
    end

    field :order_status, :order_status do
      arg(:id, non_null(:id))

      resolve(&OrdersResolver.get_order_status/3)
    end

    field :order_statuses, list_of(:order_status) do
      resolve(&OrdersResolver.list_order_status/3)
    end

    field :currencies, list_of(:currency) do
      resolve(&MoneyResolver.list_currencies/3)
    end

    field :currency, :currency do
      arg(:id, non_null(:id))

      resolve &MoneyResolver.get_currency/3
    end

    field :order, :order do
      arg(:id, non_null(:id))

      resolve(&OrdersResolver.get_order/3)
    end

    field :orders, list_of(:order) do
      resolve(&OrdersResolver.list_orders/3)
    end

    field :addresses, list_of(:address) do
      resolve(&AddressesResolver.list_addresses/3)
    end

    field :countries, list_of(:country) do
      resolve(&AddressesResolver.list_countries/3)
    end

    field :country, :country do
      arg(:id, non_null(:id))

      resolve(&AddressesResolver.get_country/3)
    end

    field :shipping_carrier, :shipping_carrier do
      arg(:id, non_null(:id))

      resolve(&ShippingsResolver.get_shipping_carrier/3)
    end

    field :shipping_carriers, list_of(:shipping_carrier) do
      resolve(&ShippingsResolver.list_shipping_carriers/3)
    end

    field :vat_groups, list_of(:vat_group) do
      resolve(&VatResolver.list_vat_groups/3)
    end

    field :vat_group, :vat_group do
      arg :id, non_null(:id)

      resolve(&VatResolver.get_vat_group/3)
    end

    field :stocks, list_of(:stock) do
      resolve(&StocksResolver.list_stocks/3)
    end

    field :stock, :stock do
      arg :id, non_null(:id)

      resolve(&StocksResolver.get_stock/3)
    end

    field :shipping_option, :shipping_option do
      arg :id, non_null(:id)

      resolve &ShippingsResolver.get_shipping_option/3
    end

    field :stats_orders, list_of(:stats_order) do
      arg :start_iso_date, :string
      arg :end_iso_date, :string

      resolve &StatsResolver.list_stats_orders/3
    end

  end

  mutation do
    field :create_product, :product do
      arg :product, non_null(:product_input)

      resolve(&ProductsResolver.create_product/3)
    end

    field :update_product, :product do
      arg :id, non_null(:id)
      arg :product, non_null(:product_input)

      resolve(&ProductsResolver.update_product/3)
    end

    field :create_configurable_option, :configurable_option do
      arg :configurable_option, non_null(:configurable_option_input)

      resolve &ProductsResolver.create_configurable_option/3
    end

    field :update_configurable_option, :configurable_option do
      arg :id, non_null(:id)
      arg :configurable_option, non_null(:configurable_option_input)

      resolve &ProductsResolver.update_configurable_option/3
    end

    field :update_configurable_item_option, :configurable_item_option do
      arg :id, non_null(:id)
      arg :configurable_item_option, non_null(:configurable_item_option_input)

      resolve &ProductsResolver.update_configurable_item_option/3
    end

    field :create_configurable_item_option, :configurable_item_option do
      arg(:configurable_item_option, :configurable_item_option_input)

      resolve(&ProductsResolver.create_configurable_item_option/3)
    end

    field :link_product_configurable_options, :product do
      arg(:product_id, non_null(:id))
      arg(:configurable_option_id, non_null(:id))

      resolve(&ProductsResolver.link_product_configurable_options/3)
    end

    field :create_user, :user do
      arg(:user, non_null(:user_input))

      resolve(&AccountsResolver.create_user/3)
    end

    field :admin_login, :string do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.admin_login/3)
    end

    field :login, :string do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.login/3)
    end

    field :logout, :boolean do
      resolve(&AccountsResolver.logout/3)
    end

    field :change_password, :boolean do
      arg(:email, non_null(:string))
      arg(:new_password, non_null(:string))
      arg(:old_password, non_null(:string))

      resolve &AccountsResolver.change_password/3
    end

    field :create_cart, :cart do
      # arg(:cart, :cart_input)

      resolve(&CartsResolver.create_cart/3)
    end

    field :add_to_cart, :cart_item do
      arg :cart_id, :id
      arg :sku, non_null(:string)
      arg :quantity, :integer

      resolve(&CartsResolver.add_to_cart/3)
    end

    field :update_cart_address, :cart do
      arg :cart_id, non_null(:id)
      arg :cart_shipping_information_address, :cart_shipping_information_address_input

      resolve(&CartsResolver.update_cart_address/3)
    end



    # field :add_to_cart, :cart_item do
    #   arg :cart_id, :id
    #   arg(:cart_item, :cart_item_input)
    #   arg(:option_item_ids, list_of(:id))

    #   resolve(&CartsResolver.add_to_cart/3)
    # end

    field :delete_cart_item, :cart_item do
      arg :id, non_null(:id)

      resolve(&CartsResolver.delete_cart_item/3)
    end

    field :update_cart_item, :cart_item do
      arg :id, non_null(:id)
      arg :cart_item, :cart_item_input

      resolve(&CartsResolver.update_cart_item/3)
    end

    field :remove_cart_item, :cart_item do
      arg(:cart_item, :cart_item_input)

      resolve(&CartsResolver.remove_cart_item/3)
    end

    field :create_order_status, :order_status do
      arg(:order_status, :order_status_input)

      resolve(&OrdersResolver.create_order_status/3)
    end

    field :create_currency, :currency do
      arg(:currency, :currency_input)

      resolve(&MoneyResolver.create_currency/3)
    end

    field :create_order_from_cart, :order do
      arg(:cart_id, non_null(:id))
      arg :order, :order_create_input
      # arg :order_address, :order_address_input

      resolve(&OrdersResolver.create_order_from_cart/3)
    end

    field :update_order, :order do
      arg :id, non_null(:id)
      arg :order, non_null(:order_update_input)

      resolve(&OrdersResolver.update_order/3)
    end

    field :create_address, :address do
      arg(:address, non_null(:address_input))

      resolve(&AddressesResolver.create_address/3)
    end

    field :create_country, :country do
      arg(:country, non_null(:country_input))

      resolve(&AddressesResolver.create_country/3)
    end

    field :add_profile_address, :profile_address do
      arg(:profile_address, non_null(:profile_address_input))

      resolve(&AccountsResolver.create_profile_address/3)
    end

    field :create_shipping_carrier, :shipping_carrier do
      arg(:shipping_carrier, non_null(:shipping_carrier_input))

      resolve(&ShippingsResolver.create_shipping_carrier/3)
    end

    field :update_shipping_carrier, :shipping_carrier do
      arg :id, non_null(:id)
      arg :shipping_carrier, non_null(:shipping_carrier_input)

      resolve &ShippingsResolver.update_shipping_carrier/3
    end

    field :create_shipping_option, :shipping_option do
      arg(:shipping_option, non_null(:shipping_option_input))

      resolve(&ShippingsResolver.create_shipping_option/3)
    end

    field :update_shipping_option, :shipping_option do
      arg :id, non_null(:id)
      arg :shipping_option, non_null(:shipping_option_input)

      resolve &ShippingsResolver.update_shipping_option/3
    end

    field :create_vat_group, :vat_group do
      arg(:vat_group, non_null(:vat_group_input))

      resolve(&VatResolver.create_vat_group/3)
    end

    field :update_vat_group, :vat_group do
      arg(:id, non_null(:id))
      arg(:vat_group, non_null(:vat_group_input))

      resolve(&VatResolver.update_vat_group/3)
    end

    field :update_country, :country do
      arg :id, non_null(:id)
      arg :country, non_null(:country_input)

      resolve &AddressesResolver.update_country/3
    end

    field :update_currency, :currency do
      arg :id, non_null(:id)
      arg :currency, non_null(:currency_input)

      resolve &MoneyResolver.update_currency/3
    end

    field :update_stock, :stock do
      arg :id, non_null(:id)
      arg :new_stock, non_null(:update_stock_input)

      resolve &StocksResolver.update_stock/3
    end

    field :update_order_status, :order_status do
      arg :id, non_null(:id)
      arg :order_status, non_null(:order_status_input)

      resolve &OrdersResolver.update_order_status/3
    end

    field :change_order_status, :order do
      arg :order_id, non_null(:id)
      arg :order_status_id, non_null(:id)

      resolve &OrdersResolver.change_order_status/3
    end

    field :forgot_password, :boolean do
      arg :email, non_null(:string)

      resolve &AccountsResolver.forgot_password/3
    end

    field :reset_password, :boolean do
      arg :token, non_null(:string)
      arg :new_password, non_null(:string)

      resolve &AccountsResolver.reset_password/3
    end

  end
end
