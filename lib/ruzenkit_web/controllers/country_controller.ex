defmodule RuzenkitWeb.CountryController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Addresses
  alias Ruzenkit.Addresses.Country

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    countries = Addresses.list_countries()
    render(conn, "index.json", countries: countries)
  end

  def create(conn, %{"country" => country_params}) do
    with {:ok, %Country{} = country} <- Addresses.create_country(country_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.country_path(conn, :show, country))
      |> render("show.json", country: country)
    end
  end

  def show(conn, %{"id" => id}) do
    country = Addresses.get_country!(id)
    render(conn, "show.json", country: country)
  end

  def update(conn, %{"id" => id, "country" => country_params}) do
    country = Addresses.get_country!(id)

    with {:ok, %Country{} = country} <- Addresses.update_country(country, country_params) do
      render(conn, "show.json", country: country)
    end
  end

  def delete(conn, %{"id" => id}) do
    country = Addresses.get_country!(id)

    with {:ok, %Country{}} <- Addresses.delete_country(country) do
      send_resp(conn, :no_content, "")
    end
  end
end
