defmodule RuzenkitWeb.OrderStatusController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Orders
  alias Ruzenkit.Orders.OrderStatus

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    order_status = Orders.list_order_status()
    render(conn, "index.json", order_status: order_status)
  end

  def create(conn, %{"order_status" => order_status_params}) do
    with {:ok, %OrderStatus{} = order_status} <- Orders.create_order_status(order_status_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.order_status_path(conn, :show, order_status))
      |> render("show.json", order_status: order_status)
    end
  end

  def show(conn, %{"id" => id}) do
    order_status = Orders.get_order_status!(id)
    render(conn, "show.json", order_status: order_status)
  end

  def update(conn, %{"id" => id, "order_status" => order_status_params}) do
    order_status = Orders.get_order_status!(id)

    with {:ok, %OrderStatus{} = order_status} <- Orders.update_order_status(order_status, order_status_params) do
      render(conn, "show.json", order_status: order_status)
    end
  end

  def delete(conn, %{"id" => id}) do
    order_status = Orders.get_order_status!(id)

    with {:ok, %OrderStatus{}} <- Orders.delete_order_status(order_status) do
      send_resp(conn, :no_content, "")
    end
  end
end
