defmodule RuzenkitWeb.ConfigurableProductController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ConfigurableProduct

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    configurable_products = Products.list_configurable_products()
    render(conn, "index.json", configurable_products: configurable_products)
  end

  def create(conn, %{"configurable_product" => configurable_product_params}) do
    with {:ok, %ConfigurableProduct{} = configurable_product} <- Products.create_configurable_product(configurable_product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.configurable_product_path(conn, :show, configurable_product))
      |> render("show.json", configurable_product: configurable_product)
    end
  end

  def show(conn, %{"id" => id}) do
    configurable_product = Products.get_configurable_product!(id)
    render(conn, "show.json", configurable_product: configurable_product)
  end

  def update(conn, %{"id" => id, "configurable_product" => configurable_product_params}) do
    configurable_product = Products.get_configurable_product!(id)

    with {:ok, %ConfigurableProduct{} = configurable_product} <- Products.update_configurable_product(configurable_product, configurable_product_params) do
      render(conn, "show.json", configurable_product: configurable_product)
    end
  end

  def delete(conn, %{"id" => id}) do
    configurable_product = Products.get_configurable_product!(id)

    with {:ok, %ConfigurableProduct{}} <- Products.delete_configurable_product(configurable_product) do
      send_resp(conn, :no_content, "")
    end
  end
end
