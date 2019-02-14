defmodule RuzenkitWeb.ConfigurableItemOptionControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ConfigurableItemOption

  @create_attrs %{
    label: "some label",
    short_label: "some short_label"
  }
  @update_attrs %{
    label: "some updated label",
    short_label: "some updated short_label"
  }
  @invalid_attrs %{label: nil, short_label: nil}

  def fixture(:configurable_item_option) do
    {:ok, configurable_item_option} = Products.create_configurable_item_option(@create_attrs)
    configurable_item_option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all configurable_item_options", %{conn: conn} do
      conn = get(conn, Routes.configurable_item_option_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create configurable_item_option" do
    test "renders configurable_item_option when data is valid", %{conn: conn} do
      conn = post(conn, Routes.configurable_item_option_path(conn, :create), configurable_item_option: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.configurable_item_option_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label",
               "short_label" => "some short_label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.configurable_item_option_path(conn, :create), configurable_item_option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update configurable_item_option" do
    setup [:create_configurable_item_option]

    test "renders configurable_item_option when data is valid", %{conn: conn, configurable_item_option: %ConfigurableItemOption{id: id} = configurable_item_option} do
      conn = put(conn, Routes.configurable_item_option_path(conn, :update, configurable_item_option), configurable_item_option: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.configurable_item_option_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label",
               "short_label" => "some updated short_label"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, configurable_item_option: configurable_item_option} do
      conn = put(conn, Routes.configurable_item_option_path(conn, :update, configurable_item_option), configurable_item_option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete configurable_item_option" do
    setup [:create_configurable_item_option]

    test "deletes chosen configurable_item_option", %{conn: conn, configurable_item_option: configurable_item_option} do
      conn = delete(conn, Routes.configurable_item_option_path(conn, :delete, configurable_item_option))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.configurable_item_option_path(conn, :show, configurable_item_option))
      end
    end
  end

  defp create_configurable_item_option(_) do
    configurable_item_option = fixture(:configurable_item_option)
    {:ok, configurable_item_option: configurable_item_option}
  end
end
