defmodule RuzenkitWeb.ChildProductControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ChildProduct

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:child_product) do
    {:ok, child_product} = Products.create_child_product(@create_attrs)
    child_product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all child_products", %{conn: conn} do
      conn = get(conn, Routes.child_product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create child_product" do
    test "renders child_product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.child_product_path(conn, :create), child_product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.child_product_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.child_product_path(conn, :create), child_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update child_product" do
    setup [:create_child_product]

    test "renders child_product when data is valid", %{conn: conn, child_product: %ChildProduct{id: id} = child_product} do
      conn = put(conn, Routes.child_product_path(conn, :update, child_product), child_product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.child_product_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, child_product: child_product} do
      conn = put(conn, Routes.child_product_path(conn, :update, child_product), child_product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete child_product" do
    setup [:create_child_product]

    test "deletes chosen child_product", %{conn: conn, child_product: child_product} do
      conn = delete(conn, Routes.child_product_path(conn, :delete, child_product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.child_product_path(conn, :show, child_product))
      end
    end
  end

  defp create_child_product(_) do
    child_product = fixture(:child_product)
    {:ok, child_product: child_product}
  end
end
