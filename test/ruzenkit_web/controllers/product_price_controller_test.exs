defmodule RuzenkitWeb.ProductPriceControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ProductPrice

  @create_attrs %{
    amount: "120.5"
  }
  @update_attrs %{
    amount: "456.7"
  }
  @invalid_attrs %{amount: nil}

  def fixture(:product_price) do
    {:ok, product_price} = Products.create_product_price(@create_attrs)
    product_price
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all product_prices", %{conn: conn} do
      conn = get(conn, Routes.product_price_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product_price" do
    test "renders product_price when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_price_path(conn, :create), product_price: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.product_price_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_price_path(conn, :create), product_price: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product_price" do
    setup [:create_product_price]

    test "renders product_price when data is valid", %{conn: conn, product_price: %ProductPrice{id: id} = product_price} do
      conn = put(conn, Routes.product_price_path(conn, :update, product_price), product_price: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.product_price_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product_price: product_price} do
      conn = put(conn, Routes.product_price_path(conn, :update, product_price), product_price: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product_price" do
    setup [:create_product_price]

    test "deletes chosen product_price", %{conn: conn, product_price: product_price} do
      conn = delete(conn, Routes.product_price_path(conn, :delete, product_price))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_price_path(conn, :show, product_price))
      end
    end
  end

  defp create_product_price(_) do
    product_price = fixture(:product_price)
    {:ok, product_price: product_price}
  end
end
