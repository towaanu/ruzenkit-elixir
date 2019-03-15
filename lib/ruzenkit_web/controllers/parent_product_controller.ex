defmodule RuzenkitWeb.ParentProductController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ParentProduct

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    parent_products = Products.list_parent_products()
    render(conn, "index.json", parent_products: parent_products)
  end

  def create(conn, %{"parent_product" => parent_product_params}) do
    with {:ok, %ParentProduct{} = parent_product} <- Products.create_parent_product(parent_product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.parent_product_path(conn, :show, parent_product))
      |> render("show.json", parent_product: parent_product)
    end
  end

  def show(conn, %{"id" => id}) do
    parent_product = Products.get_parent_product!(id)
    render(conn, "show.json", parent_product: parent_product)
  end

  def update(conn, %{"id" => id, "parent_product" => parent_product_params}) do
    parent_product = Products.get_parent_product!(id)

    with {:ok, %ParentProduct{} = parent_product} <- Products.update_parent_product(parent_product, parent_product_params) do
      render(conn, "show.json", parent_product: parent_product)
    end
  end

  def delete(conn, %{"id" => id}) do
    parent_product = Products.get_parent_product!(id)

    with {:ok, %ParentProduct{}} <- Products.delete_parent_product(parent_product) do
      send_resp(conn, :no_content, "")
    end
  end
end
