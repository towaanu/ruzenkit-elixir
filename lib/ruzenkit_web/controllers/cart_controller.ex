defmodule RuzenkitWeb.CartController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Carts
  alias Ruzenkit.Carts.Cart

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    carts = Carts.list_carts()
    render(conn, "index.json", carts: carts)
  end

  def create(conn, %{"cart" => cart_params}) do
    with {:ok, %Cart{} = cart} <- Carts.create_cart(cart_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cart_path(conn, :show, cart))
      |> render("show.json", cart: cart)
    end
  end

  def show(conn, %{"id" => id}) do
    cart = Carts.get_cart!(id)
    render(conn, "show.json", cart: cart)
  end

  def update(conn, %{"id" => id, "cart" => cart_params}) do
    cart = Carts.get_cart!(id)

    with {:ok, %Cart{} = cart} <- Carts.update_cart(cart, cart_params) do
      render(conn, "show.json", cart: cart)
    end
  end

  def delete(conn, %{"id" => id}) do
    cart = Carts.get_cart!(id)

    with {:ok, %Cart{}} <- Carts.delete_cart(cart) do
      send_resp(conn, :no_content, "")
    end
  end
end
