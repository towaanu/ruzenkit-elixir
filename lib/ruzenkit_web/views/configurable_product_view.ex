defmodule RuzenkitWeb.ConfigurableProductView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ConfigurableProductView

  def render("index.json", %{configurable_products: configurable_products}) do
    %{data: render_many(configurable_products, ConfigurableProductView, "configurable_product.json")}
  end

  def render("show.json", %{configurable_product: configurable_product}) do
    %{data: render_one(configurable_product, ConfigurableProductView, "configurable_product.json")}
  end

  def render("configurable_product.json", %{configurable_product: configurable_product}) do
    %{id: configurable_product.id}
  end
end
