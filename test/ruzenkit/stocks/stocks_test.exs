defmodule Ruzenkit.StocksTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Stocks
  alias Ruzenkit.Products
  alias Ruzenkit.Money
  alias Ruzenkit.Repo

  @valid_product_attrs %{
    sku: "test_product",
    name: "Test product !",
    description: "A super test product :D",
    stock: %{quantity: 45}
  }

  describe "stocks" do
    # alias Ruzenkit.Stocks.Stock

    def product_fixture(attrs \\ %{}) do
      {:ok, %{id: currency_id}} = Money.create_currency(%{code: "EUR", name: "euro", sign: "€"})

      {:ok, product} =
        attrs
        |> Enum.into(@valid_product_attrs)
        |> Map.put(:price, %{amount: 12.5, currency_id: currency_id})
        |> Products.create_product()

      product |> Repo.preload(:stock)
    end

    def stock_id_fixture(_attrs \\ %{}) do
      %{stock: %{id: stock_id}} = product_fixture()

      stock_id
    end

    test "update_stock/3 with stocks changes" do
      stock_id = stock_id_fixture()
      stock = Stocks.get_stock!(stock_id)
      assert stock.quantity == 45

      Stocks.update_stock(%{stock_id: stock_id, operation: 10, label: "ADD_TEST"})
      new_stock = Stocks.get_stock!(stock_id) |> Repo.preload(:stock_changes)

      assert new_stock.quantity == 55
      assert [
        %{label: "ADD_TEST", operation: 10, new_quantity: 55,stock_id: stock_id},
        %{label: "INITIAL", operation: 45, new_quantity: 45, stock_id: stock_id}
      ] = new_stock.stock_changes

      Stocks.update_stock(%{stock_id: stock_id, operation: -23, label: "REMOVE_TEST"})
      new_stock = Stocks.get_stock!(stock_id) |> Repo.preload(:stock_changes)
      assert new_stock.quantity == 32
      assert [
        %{label: "REMOVE_TEST", operation: -23, new_quantity: 32, stock_id: stock_id},
        %{label: "ADD_TEST", operation: 10, new_quantity: 55, stock_id: stock_id},
        %{label: "INITIAL", operation: 45, new_quantity: 45, stock_id: stock_id}
      ] = new_stock.stock_changes

    end

  end
end
