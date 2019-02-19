defmodule RuzenkitWeb.ShippingCarrierView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ShippingCarrierView

  def render("index.json", %{shipping_carriers: shipping_carriers}) do
    %{data: render_many(shipping_carriers, ShippingCarrierView, "shipping_carrier.json")}
  end

  def render("show.json", %{shipping_carrier: shipping_carrier}) do
    %{data: render_one(shipping_carrier, ShippingCarrierView, "shipping_carrier.json")}
  end

  def render("shipping_carrier.json", %{shipping_carrier: shipping_carrier}) do
    %{id: shipping_carrier.id,
      name: shipping_carrier.name}
  end
end
