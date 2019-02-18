defmodule RuzenkitWeb.ProductPriceController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ProductPrice

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    product_prices = Products.list_product_prices()
    render(conn, "index.json", product_prices: product_prices)
  end

  def create(conn, %{"product_price" => product_price_params}) do
    with {:ok, %ProductPrice{} = product_price} <- Products.create_product_price(product_price_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_price_path(conn, :show, product_price))
      |> render("show.json", product_price: product_price)
    end
  end

  def show(conn, %{"id" => id}) do
    product_price = Products.get_product_price!(id)
    render(conn, "show.json", product_price: product_price)
  end

  def update(conn, %{"id" => id, "product_price" => product_price_params}) do
    product_price = Products.get_product_price!(id)

    with {:ok, %ProductPrice{} = product_price} <- Products.update_product_price(product_price, product_price_params) do
      render(conn, "show.json", product_price: product_price)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_price = Products.get_product_price!(id)

    with {:ok, %ProductPrice{}} <- Products.delete_product_price(product_price) do
      send_resp(conn, :no_content, "")
    end
  end
end
