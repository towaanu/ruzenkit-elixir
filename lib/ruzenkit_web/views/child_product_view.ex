defmodule RuzenkitWeb.ChildProductView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ChildProductView

  def render("index.json", %{child_products: child_products}) do
    %{data: render_many(child_products, ChildProductView, "child_product.json")}
  end

  def render("show.json", %{child_product: child_product}) do
    %{data: render_one(child_product, ChildProductView, "child_product.json")}
  end

  def render("child_product.json", %{child_product: child_product}) do
    %{id: child_product.id}
  end
end
