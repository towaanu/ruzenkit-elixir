defmodule RuzenkitWeb.CredentialController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Accounts
  alias Ruzenkit.Accounts.Credential

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    credentials = Accounts.list_credentials()
    render(conn, "index.json", credentials: credentials)
  end

  def create(conn, %{"credential" => credential_params}) do
    with {:ok, %Credential{} = credential} <- Accounts.create_credential(credential_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.credential_path(conn, :show, credential))
      |> render("show.json", credential: credential)
    end
  end

  def show(conn, %{"id" => id}) do
    credential = Accounts.get_credential!(id)
    render(conn, "show.json", credential: credential)
  end

  def update(conn, %{"id" => id, "credential" => credential_params}) do
    credential = Accounts.get_credential!(id)

    with {:ok, %Credential{} = credential} <- Accounts.update_credential(credential, credential_params) do
      render(conn, "show.json", credential: credential)
    end
  end

  def delete(conn, %{"id" => id}) do
    credential = Accounts.get_credential!(id)

    with {:ok, %Credential{}} <- Accounts.delete_credential(credential) do
      send_resp(conn, :no_content, "")
    end
  end
end
