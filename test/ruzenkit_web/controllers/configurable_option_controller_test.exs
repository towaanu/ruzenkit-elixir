defmodule RuzenkitWeb.ConfigurableOptionControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ConfigurableOption

  @create_attrs %{
    label: "some label"
  }
  @update_attrs %{
    label: "some updated label"
  }
  @invalid_attrs %{label: nil}

  def fixture(:configurable_option) do
    {:ok, configurable_option} = Products.create_configurable_option(@create_attrs)
    configurable_option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all configurable_options", %{conn: conn} do
      conn = get(conn, Routes.configurable_option_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create configurable_option" do
    test "renders configurable_option when data is valid", %{conn: conn} do
      conn = post(conn, Routes.configurable_option_path(conn, :create), configurable_option: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.configurable_option_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.configurable_option_path(conn, :create), configurable_option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update configurable_option" do
    setup [:create_configurable_option]

    test "renders configurable_option when data is valid", %{conn: conn, configurable_option: %ConfigurableOption{id: id} = configurable_option} do
      conn = put(conn, Routes.configurable_option_path(conn, :update, configurable_option), configurable_option: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.configurable_option_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, configurable_option: configurable_option} do
      conn = put(conn, Routes.configurable_option_path(conn, :update, configurable_option), configurable_option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete configurable_option" do
    setup [:create_configurable_option]

    test "deletes chosen configurable_option", %{conn: conn, configurable_option: configurable_option} do
      conn = delete(conn, Routes.configurable_option_path(conn, :delete, configurable_option))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.configurable_option_path(conn, :show, configurable_option))
      end
    end
  end

  defp create_configurable_option(_) do
    configurable_option = fixture(:configurable_option)
    {:ok, configurable_option: configurable_option}
  end
end
