defmodule RuzenkitWeb.ParentProductView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ParentProductView

  def render("index.json", %{parent_products: parent_products}) do
    %{data: render_many(parent_products, ParentProductView, "parent_product.json")}
  end

  def render("show.json", %{parent_product: parent_product}) do
    %{data: render_one(parent_product, ParentProductView, "parent_product.json")}
  end

  def render("parent_product.json", %{parent_product: parent_product}) do
    %{id: parent_product.id}
  end
end
