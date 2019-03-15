defmodule RuzenkitWeb.ChildProductController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ChildProduct

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    child_products = Products.list_child_products()
    render(conn, "index.json", child_products: child_products)
  end

  def create(conn, %{"child_product" => child_product_params}) do
    with {:ok, %ChildProduct{} = child_product} <- Products.create_child_product(child_product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.child_product_path(conn, :show, child_product))
      |> render("show.json", child_product: child_product)
    end
  end

  def show(conn, %{"id" => id}) do
    child_product = Products.get_child_product!(id)
    render(conn, "show.json", child_product: child_product)
  end

  def update(conn, %{"id" => id, "child_product" => child_product_params}) do
    child_product = Products.get_child_product!(id)

    with {:ok, %ChildProduct{} = child_product} <- Products.update_child_product(child_product, child_product_params) do
      render(conn, "show.json", child_product: child_product)
    end
  end

  def delete(conn, %{"id" => id}) do
    child_product = Products.get_child_product!(id)

    with {:ok, %ChildProduct{}} <- Products.delete_child_product(child_product) do
      send_resp(conn, :no_content, "")
    end
  end
end
