defmodule RuzenkitWeb.OrderStatusControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Orders
  alias Ruzenkit.Orders.OrderStatus

  @create_attrs %{
    label: "some label"
  }
  @update_attrs %{
    label: "some updated label"
  }
  @invalid_attrs %{label: nil}

  def fixture(:order_status) do
    {:ok, order_status} = Orders.create_order_status(@create_attrs)
    order_status
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all order_status", %{conn: conn} do
      conn = get(conn, Routes.order_status_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create order_status" do
    test "renders order_status when data is valid", %{conn: conn} do
      conn = post(conn, Routes.order_status_path(conn, :create), order_status: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.order_status_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_status_path(conn, :create), order_status: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update order_status" do
    setup [:create_order_status]

    test "renders order_status when data is valid", %{conn: conn, order_status: %OrderStatus{id: id} = order_status} do
      conn = put(conn, Routes.order_status_path(conn, :update, order_status), order_status: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.order_status_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, order_status: order_status} do
      conn = put(conn, Routes.order_status_path(conn, :update, order_status), order_status: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete order_status" do
    setup [:create_order_status]

    test "deletes chosen order_status", %{conn: conn, order_status: order_status} do
      conn = delete(conn, Routes.order_status_path(conn, :delete, order_status))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.order_status_path(conn, :show, order_status))
      end
    end
  end

  defp create_order_status(_) do
    order_status = fixture(:order_status)
    {:ok, order_status: order_status}
  end
end
