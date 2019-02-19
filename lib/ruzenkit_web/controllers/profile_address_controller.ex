defmodule RuzenkitWeb.ProfileAddressController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Accounts
  alias Ruzenkit.Accounts.ProfileAddress

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    profile_addresses = Accounts.list_profile_addresses()
    render(conn, "index.json", profile_addresses: profile_addresses)
  end

  def create(conn, %{"profile_address" => profile_address_params}) do
    with {:ok, %ProfileAddress{} = profile_address} <- Accounts.create_profile_address(profile_address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.profile_address_path(conn, :show, profile_address))
      |> render("show.json", profile_address: profile_address)
    end
  end

  def show(conn, %{"id" => id}) do
    profile_address = Accounts.get_profile_address!(id)
    render(conn, "show.json", profile_address: profile_address)
  end

  def update(conn, %{"id" => id, "profile_address" => profile_address_params}) do
    profile_address = Accounts.get_profile_address!(id)

    with {:ok, %ProfileAddress{} = profile_address} <- Accounts.update_profile_address(profile_address, profile_address_params) do
      render(conn, "show.json", profile_address: profile_address)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile_address = Accounts.get_profile_address!(id)

    with {:ok, %ProfileAddress{}} <- Accounts.delete_profile_address(profile_address) do
      send_resp(conn, :no_content, "")
    end
  end
end
