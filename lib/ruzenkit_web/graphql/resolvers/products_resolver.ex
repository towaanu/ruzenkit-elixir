defmodule RuzenkitWeb.Graphql.ProductsResolver do
  alias Ruzenkit.Products

  def list_products(_root, _args, _info) do
    products = Products.list_products()
    {:ok, products}
  end

  def create_product(_root, args, _info) do
    case Products.create_product(args) do
      {:ok, product} ->
        {:ok, product}

      _error ->
        {:error, "could not create product"}
    end
  end

  def get_product(_root, %{id: id}, _info) do
    case Products.get_product(id) do
      nil ->
        {:error, "product with id #{id} not found"}

      product ->
        {:ok, product}
    end
  end
end
