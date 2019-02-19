defmodule RuzenkitWeb.AddressControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Addresses
  alias Ruzenkit.Addresses.Address

  @create_attrs %{
    building: "some building",
    city: "some city",
    extra_info: "some extra_info",
    first_name: "some first_name",
    floor: "some floor",
    last_name: "some last_name",
    place: "some place",
    zip_code: "some zip_code"
  }
  @update_attrs %{
    building: "some updated building",
    city: "some updated city",
    extra_info: "some updated extra_info",
    first_name: "some updated first_name",
    floor: "some updated floor",
    last_name: "some updated last_name",
    place: "some updated place",
    zip_code: "some updated zip_code"
  }
  @invalid_attrs %{building: nil, city: nil, extra_info: nil, first_name: nil, floor: nil, last_name: nil, place: nil, zip_code: nil}

  def fixture(:address) do
    {:ok, address} = Addresses.create_address(@create_attrs)
    address
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all addresses", %{conn: conn} do
      conn = get(conn, Routes.address_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create address" do
    test "renders address when data is valid", %{conn: conn} do
      conn = post(conn, Routes.address_path(conn, :create), address: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.address_path(conn, :show, id))

      assert %{
               "id" => id,
               "building" => "some building",
               "city" => "some city",
               "extra_info" => "some extra_info",
               "first_name" => "some first_name",
               "floor" => "some floor",
               "last_name" => "some last_name",
               "place" => "some place",
               "zip_code" => "some zip_code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.address_path(conn, :create), address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update address" do
    setup [:create_address]

    test "renders address when data is valid", %{conn: conn, address: %Address{id: id} = address} do
      conn = put(conn, Routes.address_path(conn, :update, address), address: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.address_path(conn, :show, id))

      assert %{
               "id" => id,
               "building" => "some updated building",
               "city" => "some updated city",
               "extra_info" => "some updated extra_info",
               "first_name" => "some updated first_name",
               "floor" => "some updated floor",
               "last_name" => "some updated last_name",
               "place" => "some updated place",
               "zip_code" => "some updated zip_code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, address: address} do
      conn = put(conn, Routes.address_path(conn, :update, address), address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete address" do
    setup [:create_address]

    test "deletes chosen address", %{conn: conn, address: address} do
      conn = delete(conn, Routes.address_path(conn, :delete, address))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.address_path(conn, :show, address))
      end
    end
  end

  defp create_address(_) do
    address = fixture(:address)
    {:ok, address: address}
  end
end
