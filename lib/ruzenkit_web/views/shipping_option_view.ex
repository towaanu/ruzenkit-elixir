defmodule RuzenkitWeb.ShippingOptionView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ShippingOptionView

  def render("index.json", %{shipping_options: shipping_options}) do
    %{data: render_many(shipping_options, ShippingOptionView, "shipping_option.json")}
  end

  def render("show.json", %{shipping_option: shipping_option}) do
    %{data: render_one(shipping_option, ShippingOptionView, "shipping_option.json")}
  end

  def render("shipping_option.json", %{shipping_option: shipping_option}) do
    %{id: shipping_option.id,
      name: shipping_option.name,
      description: shipping_option.description,
      shipping_time: shipping_option.shipping_time}
  end
end
