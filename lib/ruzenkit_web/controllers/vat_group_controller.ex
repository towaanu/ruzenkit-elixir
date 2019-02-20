defmodule RuzenkitWeb.VatGroupController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Vat
  alias Ruzenkit.Vat.VatGroup

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    vat_groups = Vat.list_vat_groups()
    render(conn, "index.json", vat_groups: vat_groups)
  end

  def create(conn, %{"vat_group" => vat_group_params}) do
    with {:ok, %VatGroup{} = vat_group} <- Vat.create_vat_group(vat_group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.vat_group_path(conn, :show, vat_group))
      |> render("show.json", vat_group: vat_group)
    end
  end

  def show(conn, %{"id" => id}) do
    vat_group = Vat.get_vat_group!(id)
    render(conn, "show.json", vat_group: vat_group)
  end

  def update(conn, %{"id" => id, "vat_group" => vat_group_params}) do
    vat_group = Vat.get_vat_group!(id)

    with {:ok, %VatGroup{} = vat_group} <- Vat.update_vat_group(vat_group, vat_group_params) do
      render(conn, "show.json", vat_group: vat_group)
    end
  end

  def delete(conn, %{"id" => id}) do
    vat_group = Vat.get_vat_group!(id)

    with {:ok, %VatGroup{}} <- Vat.delete_vat_group(vat_group) do
      send_resp(conn, :no_content, "")
    end
  end
end
