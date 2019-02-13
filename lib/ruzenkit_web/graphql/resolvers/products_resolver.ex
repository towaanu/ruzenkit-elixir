defmodule RuzenkitWeb.Graphql.ProductsResolver do
  alias Ruzenkit.Products
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def list_products(_root, _args, _info) do
    products = Products.list_products()
    {:ok, products}
  end

  def create_product(_root, args, _info) do
    case Products.create_product(args) do
      {:ok, product} ->
        {:ok, product}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new product", error)}
    end
  end

  def get_product(_root, %{id: id}, _info) do
    case Products.get_product(id) do
      nil ->
        {:error, "product with id #{id} not found"}

      product ->
        {:ok, product}
    end
  end

  def list_configurable_options(_root, _args, _info) do
    configurable_options = Products.list_configurable_options()
    {:ok, configurable_options}
  end

  def create_configurable_option(_root, args, _info) do
    case Products.create_configurable_option(args) do
      {:ok, configurable_option} ->
        {:ok, configurable_option}

      error ->
        {:error, changeset_error_to_graphql("could not create configurable option", error)}
        # {:error, "could not create configurable option"}
    end
  end

  def link_product_configurable_options(
        _root,
        %{product_id: product_id, configurable_option_id: configurable_option_id},
        _info
      ) do
    case Products.link_product_configurable_options(product_id, configurable_option_id) do
      {:ok, product} ->
        {:ok, product}

      error ->
        {:error,
         changeset_error_to_graphql(
           "could not link product #{product_id} with configurable option #{configurable_option_id}",
           error
         )}
    end
  end
end
