defmodule RuzenkitWeb.CurrencyController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Money
  alias Ruzenkit.Money.Currency

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    currencies = Money.list_currencies()
    render(conn, "index.json", currencies: currencies)
  end

  def create(conn, %{"currency" => currency_params}) do
    with {:ok, %Currency{} = currency} <- Money.create_currency(currency_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.currency_path(conn, :show, currency))
      |> render("show.json", currency: currency)
    end
  end

  def show(conn, %{"id" => id}) do
    currency = Money.get_currency!(id)
    render(conn, "show.json", currency: currency)
  end

  def update(conn, %{"id" => id, "currency" => currency_params}) do
    currency = Money.get_currency!(id)

    with {:ok, %Currency{} = currency} <- Money.update_currency(currency, currency_params) do
      render(conn, "show.json", currency: currency)
    end
  end

  def delete(conn, %{"id" => id}) do
    currency = Money.get_currency!(id)

    with {:ok, %Currency{}} <- Money.delete_currency(currency) do
      send_resp(conn, :no_content, "")
    end
  end
end
