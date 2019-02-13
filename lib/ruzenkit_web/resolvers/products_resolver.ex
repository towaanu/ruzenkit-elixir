defmodule RuzenkitWeb.ProductsResolver do
  alias Ruzenkit.Products

  def products(_root, _args, _info) do
    products = Products.list_products()
    {:ok, products}
  end
end
