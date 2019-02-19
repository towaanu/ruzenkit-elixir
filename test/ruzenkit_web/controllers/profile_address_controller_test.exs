defmodule RuzenkitWeb.ProfileAddressControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Accounts
  alias Ruzenkit.Accounts.ProfileAddress

  @create_attrs %{
    is_default: true
  }
  @update_attrs %{
    is_default: false
  }
  @invalid_attrs %{is_default: nil}

  def fixture(:profile_address) do
    {:ok, profile_address} = Accounts.create_profile_address(@create_attrs)
    profile_address
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all profile_addresses", %{conn: conn} do
      conn = get(conn, Routes.profile_address_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create profile_address" do
    test "renders profile_address when data is valid", %{conn: conn} do
      conn = post(conn, Routes.profile_address_path(conn, :create), profile_address: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.profile_address_path(conn, :show, id))

      assert %{
               "id" => id,
               "is_default" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.profile_address_path(conn, :create), profile_address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update profile_address" do
    setup [:create_profile_address]

    test "renders profile_address when data is valid", %{conn: conn, profile_address: %ProfileAddress{id: id} = profile_address} do
      conn = put(conn, Routes.profile_address_path(conn, :update, profile_address), profile_address: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.profile_address_path(conn, :show, id))

      assert %{
               "id" => id,
               "is_default" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, profile_address: profile_address} do
      conn = put(conn, Routes.profile_address_path(conn, :update, profile_address), profile_address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete profile_address" do
    setup [:create_profile_address]

    test "deletes chosen profile_address", %{conn: conn, profile_address: profile_address} do
      conn = delete(conn, Routes.profile_address_path(conn, :delete, profile_address))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.profile_address_path(conn, :show, profile_address))
      end
    end
  end

  defp create_profile_address(_) do
    profile_address = fixture(:profile_address)
    {:ok, profile_address: profile_address}
  end
end
