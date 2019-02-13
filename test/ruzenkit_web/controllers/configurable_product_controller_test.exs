defmodule RuzenkitWeb.ConfigurableProductControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ConfigurableProduct

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:configurable_product) do
    {:ok, configurable_product} = Products.create_configurable_product(@create_attrs)
    configurable_product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all configurable_products", %{conn: conn} do
      conn = get(conn, Routes.configurable_product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create configurable_product" do
    test "renders configurable_product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.configurable_product_path(conn, :create), configurable_product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.configurable_product_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.configurable_product_path(conn, :create), configurable_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update configurable_product" do
    setup [:create_configurable_product]

    test "renders configurable_product when data is valid", %{conn: conn, configurable_product: %ConfigurableProduct{id: id} = configurable_product} do
      conn = put(conn, Routes.configurable_product_path(conn, :update, configurable_product), configurable_product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.configurable_product_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, configurable_product: configurable_product} do
      conn = put(conn, Routes.configurable_product_path(conn, :update, configurable_product), configurable_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete configurable_product" do
    setup [:create_configurable_product]

    test "deletes chosen configurable_product", %{conn: conn, configurable_product: configurable_product} do
      conn = delete(conn, Routes.configurable_product_path(conn, :delete, configurable_product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.configurable_product_path(conn, :show, configurable_product))
      end
    end
  end

  defp create_configurable_product(_) do
    configurable_product = fixture(:configurable_product)
    {:ok, configurable_product: configurable_product}
  end
end
