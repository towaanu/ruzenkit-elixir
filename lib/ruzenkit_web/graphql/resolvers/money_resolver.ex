defmodule RuzenkitWeb.Graphql.MoneyResolver do
  alias Ruzenkit.Money
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def create_currency(_root, %{currency: currency}, %{context: %{is_admin: true}}) do
    case Money.create_currency(currency) do
      {:ok, currency} ->
        {:ok, currency}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new currency", error)}
    end
  end

  def create_currency(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def list_currencies(_root, _args, %{context: %{is_admin: true}}),
    do: {:ok, Money.list_currencies()}

  # if not admin return error message
  def list_currencies(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def update_currency(_root, %{id: id, currency: currency_params}, %{context: %{is_admin: true}}) do
    db_currency = Money.get_currency!(id)

    case Money.update_currency(db_currency, currency_params) do
      {:ok, currency} ->
        {:ok, currency}

      {:error, error} ->
        {:error, changeset_error_to_graphql("could not update currency", error)}
    end
  end

  def update_currency(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def get_currency(_root, %{id: id}, _info) do
    case Money.get_currency(id) do
      nil ->
        {:error, "currency with id #{id} not found"}

      currency ->
        {:ok, currency}
    end
  end
end
