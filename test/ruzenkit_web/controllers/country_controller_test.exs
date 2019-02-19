defmodule RuzenkitWeb.CountryControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Addresses
  alias Ruzenkit.Addresses.Country

  @create_attrs %{
    english_name: "some english_name",
    local_name: "some local_name",
    long_iso_code: "some long_iso_code",
    short_iso_code: "some short_iso_code"
  }
  @update_attrs %{
    english_name: "some updated english_name",
    local_name: "some updated local_name",
    long_iso_code: "some updated long_iso_code",
    short_iso_code: "some updated short_iso_code"
  }
  @invalid_attrs %{english_name: nil, local_name: nil, long_iso_code: nil, short_iso_code: nil}

  def fixture(:country) do
    {:ok, country} = Addresses.create_country(@create_attrs)
    country
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all countries", %{conn: conn} do
      conn = get(conn, Routes.country_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create country" do
    test "renders country when data is valid", %{conn: conn} do
      conn = post(conn, Routes.country_path(conn, :create), country: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.country_path(conn, :show, id))

      assert %{
               "id" => id,
               "english_name" => "some english_name",
               "local_name" => "some local_name",
               "long_iso_code" => "some long_iso_code",
               "short_iso_code" => "some short_iso_code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.country_path(conn, :create), country: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update country" do
    setup [:create_country]

    test "renders country when data is valid", %{conn: conn, country: %Country{id: id} = country} do
      conn = put(conn, Routes.country_path(conn, :update, country), country: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.country_path(conn, :show, id))

      assert %{
               "id" => id,
               "english_name" => "some updated english_name",
               "local_name" => "some updated local_name",
               "long_iso_code" => "some updated long_iso_code",
               "short_iso_code" => "some updated short_iso_code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, country: country} do
      conn = put(conn, Routes.country_path(conn, :update, country), country: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete country" do
    setup [:create_country]

    test "deletes chosen country", %{conn: conn, country: country} do
      conn = delete(conn, Routes.country_path(conn, :delete, country))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.country_path(conn, :show, country))
      end
    end
  end

  defp create_country(_) do
    country = fixture(:country)
    {:ok, country: country}
  end
end
