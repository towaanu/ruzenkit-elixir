defmodule RuzenkitWeb.ProductPriceView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ProductPriceView

  def render("index.json", %{product_prices: product_prices}) do
    %{data: render_many(product_prices, ProductPriceView, "product_price.json")}
  end

  def render("show.json", %{product_price: product_price}) do
    %{data: render_one(product_price, ProductPriceView, "product_price.json")}
  end

  def render("product_price.json", %{product_price: product_price}) do
    %{id: product_price.id,
      amount: product_price.amount}
  end
end
