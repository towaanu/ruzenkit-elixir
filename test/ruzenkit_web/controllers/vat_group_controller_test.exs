defmodule RuzenkitWeb.VatGroupControllerTest do
  use RuzenkitWeb.ConnCase

  alias Ruzenkit.Vat
  alias Ruzenkit.Vat.VatGroup

  @create_attrs %{
    label: "some label",
    rate: 120.5
  }
  @update_attrs %{
    label: "some updated label",
    rate: 456.7
  }
  @invalid_attrs %{label: nil, rate: nil}

  def fixture(:vat_group) do
    {:ok, vat_group} = Vat.create_vat_group(@create_attrs)
    vat_group
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vat_groups", %{conn: conn} do
      conn = get(conn, Routes.vat_group_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vat_group" do
    test "renders vat_group when data is valid", %{conn: conn} do
      conn = post(conn, Routes.vat_group_path(conn, :create), vat_group: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.vat_group_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label",
               "rate" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.vat_group_path(conn, :create), vat_group: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vat_group" do
    setup [:create_vat_group]

    test "renders vat_group when data is valid", %{conn: conn, vat_group: %VatGroup{id: id} = vat_group} do
      conn = put(conn, Routes.vat_group_path(conn, :update, vat_group), vat_group: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.vat_group_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label",
               "rate" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vat_group: vat_group} do
      conn = put(conn, Routes.vat_group_path(conn, :update, vat_group), vat_group: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vat_group" do
    setup [:create_vat_group]

    test "deletes chosen vat_group", %{conn: conn, vat_group: vat_group} do
      conn = delete(conn, Routes.vat_group_path(conn, :delete, vat_group))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.vat_group_path(conn, :show, vat_group))
      end
    end
  end

  defp create_vat_group(_) do
    vat_group = fixture(:vat_group)
    {:ok, vat_group: vat_group}
  end
end
