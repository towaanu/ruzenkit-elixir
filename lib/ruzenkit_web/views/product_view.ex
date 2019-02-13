defmodule RuzenkitWeb.ProductView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      sku: product.sku,
      name: product.name,
      description: product.description}
  end
end
