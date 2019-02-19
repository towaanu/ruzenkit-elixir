defmodule RuzenkitWeb.ShippingOptionControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Shippings
  alias Ruzenkit.Shippings.ShippingOption

  @create_attrs %{
    description: "some description",
    name: "some name",
    shipping_time: ~T[14:00:00]
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    shipping_time: ~T[15:01:01]
  }
  @invalid_attrs %{description: nil, name: nil, shipping_time: nil}

  def fixture(:shipping_option) do
    {:ok, shipping_option} = Shippings.create_shipping_option(@create_attrs)
    shipping_option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shipping_options", %{conn: conn} do
      conn = get(conn, Routes.shipping_option_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create shipping_option" do
    test "renders shipping_option when data is valid", %{conn: conn} do
      conn = post(conn, Routes.shipping_option_path(conn, :create), shipping_option: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.shipping_option_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "shipping_time" => "14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.shipping_option_path(conn, :create), shipping_option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shipping_option" do
    setup [:create_shipping_option]

    test "renders shipping_option when data is valid", %{conn: conn, shipping_option: %ShippingOption{id: id} = shipping_option} do
      conn = put(conn, Routes.shipping_option_path(conn, :update, shipping_option), shipping_option: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.shipping_option_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name",
               "shipping_time" => "15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shipping_option: shipping_option} do
      conn = put(conn, Routes.shipping_option_path(conn, :update, shipping_option), shipping_option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shipping_option" do
    setup [:create_shipping_option]

    test "deletes chosen shipping_option", %{conn: conn, shipping_option: shipping_option} do
      conn = delete(conn, Routes.shipping_option_path(conn, :delete, shipping_option))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.shipping_option_path(conn, :show, shipping_option))
      end
    end
  end

  defp create_shipping_option(_) do
    shipping_option = fixture(:shipping_option)
    {:ok, shipping_option: shipping_option}
  end
end
