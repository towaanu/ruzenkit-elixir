defmodule RuzenkitWeb.OrderItemController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Orders
  alias Ruzenkit.Orders.OrderItem

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    order_items = Orders.list_order_items()
    render(conn, "index.json", order_items: order_items)
  end

  def create(conn, %{"order_item" => order_item_params}) do
    with {:ok, %OrderItem{} = order_item} <- Orders.create_order_item(order_item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.order_item_path(conn, :show, order_item))
      |> render("show.json", order_item: order_item)
    end
  end

  def show(conn, %{"id" => id}) do
    order_item = Orders.get_order_item!(id)
    render(conn, "show.json", order_item: order_item)
  end

  def update(conn, %{"id" => id, "order_item" => order_item_params}) do
    order_item = Orders.get_order_item!(id)

    with {:ok, %OrderItem{} = order_item} <- Orders.update_order_item(order_item, order_item_params) do
      render(conn, "show.json", order_item: order_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item = Orders.get_order_item!(id)

    with {:ok, %OrderItem{}} <- Orders.delete_order_item(order_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
