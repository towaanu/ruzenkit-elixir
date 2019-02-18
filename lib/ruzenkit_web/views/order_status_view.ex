defmodule RuzenkitWeb.OrderStatusView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.OrderStatusView

  def render("index.json", %{order_status: order_status}) do
    %{data: render_many(order_status, OrderStatusView, "order_status.json")}
  end

  def render("show.json", %{order_status: order_status}) do
    %{data: render_one(order_status, OrderStatusView, "order_status.json")}
  end

  def render("order_status.json", %{order_status: order_status}) do
    %{id: order_status.id,
      label: order_status.label}
  end
end
