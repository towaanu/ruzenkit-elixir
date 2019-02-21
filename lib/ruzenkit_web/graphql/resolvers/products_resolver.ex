defmodule RuzenkitWeb.Graphql.ProductsResolver do
  alias Ruzenkit.Products
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def list_products(_root, _args, _info) do
    products = Products.list_products()
    {:ok, products}
  end

  def create_product(_root, %{product: product}, %{context: %{is_admin: true}}) do
    case Products.create_product(product) do
      {:ok, product} ->
        {:ok, product}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new product", error)}
    end
  end

  def create_product(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

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

  def get_configurable_option(_root, %{id: id}, _info) do
    case Products.get_configurable_option(id) do
      nil ->
        {:error, "configurable option with id #{id} not found"}

      configurable_option ->
        {:ok, configurable_option}
    end
  end

  def get_configurable_item_options(
        _root,
        %{configurable_option_id: configurable_option_id},
        _info
      ) do
    configurable_item_options =
      Products.get_configurable_item_options_by_co(configurable_option_id)

    {:ok, configurable_item_options}
  end

  def create_configurable_option(_root, %{configurable_option: configurable_option}, %{context: %{is_admin: true}}) do
    case Products.create_configurable_option(configurable_option) do
      {:ok, configurable_option} ->
        {:ok, configurable_option}

      error ->
        {:error, changeset_error_to_graphql("could not create configurable option", error)}
        # {:error, "could not create configurable option"}
    end
  end

  def create_configurable_option(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def update_configurable_option(_root, %{id: id, configurable_option: configurable_option}, %{
        context: %{is_admin: true}
      }) do
    db_configurable_option = Products.get_configurable_option!(id)

    case Products.update_configurable_option(db_configurable_option, configurable_option) do
      {:ok, configurable_option} ->
        {:ok, configurable_option}

      error ->
        {:error, changeset_error_to_graphql("could not update configurable option", error)}
        # {:error, "could not create configurable option"}
    end
  end

  def update_configurable_option(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def create_configurable_item_option(
        _root,
        %{configurable_item_option: configurable_item_option},
        %{context: %{is_admin: true}}
      ) do
    case Products.create_configurable_item_option(configurable_item_option) do
      {:ok, configurable_item_option} ->
        {:ok, configurable_item_option}

      {:error, error} ->
        {:error,
         changeset_error_to_graphql("unable to create new configurable item option", error)}
    end
  end

  def create_configurable_item_option(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def link_product_configurable_options(
        _root,
        %{product_id: product_id, configurable_option_id: configurable_option_id},
        %{context: %{is_admin: true}}
      ) do
    case Products.link_product_configurable_options(product_id, configurable_option_id) do
      {:ok, product} ->
        {:ok, product}

      error ->
        {:error,
         changeset_error_to_graphql(
           "could not link product #{product_id} with configurable option #{
             configurable_option_id
           }",
           error
         )}
    end
  end

  def link_product_configurable_options(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}
end
