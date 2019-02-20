defmodule RuzenkitWeb.ParentProductControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ParentProduct

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:parent_product) do
    {:ok, parent_product} = Products.create_parent_product(@create_attrs)
    parent_product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all parent_products", %{conn: conn} do
      conn = get(conn, Routes.parent_product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create parent_product" do
    test "renders parent_product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parent_product_path(conn, :create), parent_product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.parent_product_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parent_product_path(conn, :create), parent_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update parent_product" do
    setup [:create_parent_product]

    test "renders parent_product when data is valid", %{conn: conn, parent_product: %ParentProduct{id: id} = parent_product} do
      conn = put(conn, Routes.parent_product_path(conn, :update, parent_product), parent_product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.parent_product_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, parent_product: parent_product} do
      conn = put(conn, Routes.parent_product_path(conn, :update, parent_product), parent_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete parent_product" do
    setup [:create_parent_product]

    test "deletes chosen parent_product", %{conn: conn, parent_product: parent_product} do
      conn = delete(conn, Routes.parent_product_path(conn, :delete, parent_product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.parent_product_path(conn, :show, parent_product))
      end
    end
  end

  defp create_parent_product(_) do
    parent_product = fixture(:parent_product)
    {:ok, parent_product: parent_product}
  end
end
