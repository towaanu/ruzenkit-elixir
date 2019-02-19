defmodule RuzenkitWeb.ShippingCarrierController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Shippings
  alias Ruzenkit.Shippings.ShippingCarrier

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    shipping_carriers = Shippings.list_shipping_carriers()
    render(conn, "index.json", shipping_carriers: shipping_carriers)
  end

  def create(conn, %{"shipping_carrier" => shipping_carrier_params}) do
    with {:ok, %ShippingCarrier{} = shipping_carrier} <- Shippings.create_shipping_carrier(shipping_carrier_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.shipping_carrier_path(conn, :show, shipping_carrier))
      |> render("show.json", shipping_carrier: shipping_carrier)
    end
  end

  def show(conn, %{"id" => id}) do
    shipping_carrier = Shippings.get_shipping_carrier!(id)
    render(conn, "show.json", shipping_carrier: shipping_carrier)
  end

  def update(conn, %{"id" => id, "shipping_carrier" => shipping_carrier_params}) do
    shipping_carrier = Shippings.get_shipping_carrier!(id)

    with {:ok, %ShippingCarrier{} = shipping_carrier} <- Shippings.update_shipping_carrier(shipping_carrier, shipping_carrier_params) do
      render(conn, "show.json", shipping_carrier: shipping_carrier)
    end
  end

  def delete(conn, %{"id" => id}) do
    shipping_carrier = Shippings.get_shipping_carrier!(id)

    with {:ok, %ShippingCarrier{}} <- Shippings.delete_shipping_carrier(shipping_carrier) do
      send_resp(conn, :no_content, "")
    end
  end
end
