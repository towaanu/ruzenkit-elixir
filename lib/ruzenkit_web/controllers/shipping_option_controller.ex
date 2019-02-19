defmodule RuzenkitWeb.ShippingOptionController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Shippings
  alias Ruzenkit.Shippings.ShippingOption

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    shipping_options = Shippings.list_shipping_options()
    render(conn, "index.json", shipping_options: shipping_options)
  end

  def create(conn, %{"shipping_option" => shipping_option_params}) do
    with {:ok, %ShippingOption{} = shipping_option} <- Shippings.create_shipping_option(shipping_option_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.shipping_option_path(conn, :show, shipping_option))
      |> render("show.json", shipping_option: shipping_option)
    end
  end

  def show(conn, %{"id" => id}) do
    shipping_option = Shippings.get_shipping_option!(id)
    render(conn, "show.json", shipping_option: shipping_option)
  end

  def update(conn, %{"id" => id, "shipping_option" => shipping_option_params}) do
    shipping_option = Shippings.get_shipping_option!(id)

    with {:ok, %ShippingOption{} = shipping_option} <- Shippings.update_shipping_option(shipping_option, shipping_option_params) do
      render(conn, "show.json", shipping_option: shipping_option)
    end
  end

  def delete(conn, %{"id" => id}) do
    shipping_option = Shippings.get_shipping_option!(id)

    with {:ok, %ShippingOption{}} <- Shippings.delete_shipping_option(shipping_option) do
      send_resp(conn, :no_content, "")
    end
  end
end
