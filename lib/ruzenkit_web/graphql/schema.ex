defmodule RuzenkitWeb.Graphql.Schema do

  use Absinthe.Schema

  alias RuzenkitWeb.Graphql.ProductsResolver
  alias RuzenkitWeb.Graphql.AccountsResolver
  alias RuzenkitWeb.Graphql.Types
  alias Ruzenkit.EctoDataloader

  import_types Types.Products
  import_types Types.Accounts

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(:db, EctoDataloader.data()) # data from database with ecto

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    # this is the query entry point to our app
    field :products, list_of(:product) do
      resolve &ProductsResolver.list_products/3
    end

    field :product, :product do
      arg :id, non_null(:id)

      resolve &ProductsResolver.get_product/3
    end

    field :configurable_options, list_of(:configurable_option) do
      resolve &ProductsResolver.list_configurable_options/3
    end

    field :users, list_of(:user) do
      resolve &AccountsResolver.list_users/3
    end

    field :user, non_null(:user) do
      arg :id, non_null(:id)

      resolve &AccountsResolver.get_user/3
    end

    field :me, :string do
      resolve &AccountsResolver.me/3
    end

  end

  mutation do

    field :create_product, :product do
      arg :product, non_null(:product_input)

      resolve &ProductsResolver.create_product/3
    end

    field :create_configurable_option, :configurable_option do
      arg :label, non_null(:string)

      resolve &ProductsResolver.create_configurable_option/3
    end

    field :create_configurable_item_option, :configurable_item_option do
      arg :configurable_item_option, :configurable_item_option_input

      resolve &ProductsResolver.create_configurable_item_option/3
    end

    field :link_product_configurable_options, :product do
      arg :product_id, non_null(:id)
      arg :configurable_option_id, non_null(:id)

      resolve &ProductsResolver.link_product_configurable_options/3

    end

    field :create_user, non_null(:user) do
      arg :user, non_null(:user_input)

      resolve &AccountsResolver.create_user/3
    end

    field :login, non_null(:string) do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &AccountsResolver.login/3
    end

  end

end
