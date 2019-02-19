defmodule RuzenkitWeb.ShippingCarrierControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Shippings
  alias Ruzenkit.Shippings.ShippingCarrier

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:shipping_carrier) do
    {:ok, shipping_carrier} = Shippings.create_shipping_carrier(@create_attrs)
    shipping_carrier
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shipping_carriers", %{conn: conn} do
      conn = get(conn, Routes.shipping_carrier_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create shipping_carrier" do
    test "renders shipping_carrier when data is valid", %{conn: conn} do
      conn = post(conn, Routes.shipping_carrier_path(conn, :create), shipping_carrier: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.shipping_carrier_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.shipping_carrier_path(conn, :create), shipping_carrier: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shipping_carrier" do
    setup [:create_shipping_carrier]

    test "renders shipping_carrier when data is valid", %{conn: conn, shipping_carrier: %ShippingCarrier{id: id} = shipping_carrier} do
      conn = put(conn, Routes.shipping_carrier_path(conn, :update, shipping_carrier), shipping_carrier: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.shipping_carrier_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shipping_carrier: shipping_carrier} do
      conn = put(conn, Routes.shipping_carrier_path(conn, :update, shipping_carrier), shipping_carrier: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shipping_carrier" do
    setup [:create_shipping_carrier]

    test "deletes chosen shipping_carrier", %{conn: conn, shipping_carrier: shipping_carrier} do
      conn = delete(conn, Routes.shipping_carrier_path(conn, :delete, shipping_carrier))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.shipping_carrier_path(conn, :show, shipping_carrier))
      end
    end
  end

  defp create_shipping_carrier(_) do
    shipping_carrier = fixture(:shipping_carrier)
    {:ok, shipping_carrier: shipping_carrier}
  end
end
