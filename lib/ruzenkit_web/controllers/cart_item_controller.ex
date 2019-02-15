defmodule RuzenkitWeb.CartItemController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Carts
  alias Ruzenkit.Carts.CartItem

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    cart_items = Carts.list_cart_items()
    render(conn, "index.json", cart_items: cart_items)
  end

  def create(conn, %{"cart_item" => cart_item_params}) do
    with {:ok, %CartItem{} = cart_item} <- Carts.create_cart_item(cart_item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cart_item_path(conn, :show, cart_item))
      |> render("show.json", cart_item: cart_item)
    end
  end

  def show(conn, %{"id" => id}) do
    cart_item = Carts.get_cart_item!(id)
    render(conn, "show.json", cart_item: cart_item)
  end

  def update(conn, %{"id" => id, "cart_item" => cart_item_params}) do
    cart_item = Carts.get_cart_item!(id)

    with {:ok, %CartItem{} = cart_item} <- Carts.update_cart_item(cart_item, cart_item_params) do
      render(conn, "show.json", cart_item: cart_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    cart_item = Carts.get_cart_item!(id)

    with {:ok, %CartItem{}} <- Carts.delete_cart_item(cart_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
