defmodule RuzenkitWeb.Graphql.StocksResolver do
  alias Ruzenkit.Stocks
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def update_stock(_root, %{new_stock: new_stock_params, id: stock_id}, %{
        context: %{is_admin: true}
      }) do
    new_stock_params
    |> Map.put(:stock_id, stock_id)
    |> Stocks.update_stock()
    |> case do
      {:ok, stock} -> {:ok, stock}
      {:error, error} -> {:error, changeset_error_to_graphql("Unable to update stock", error)}
    end
  end

  def update_stock(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def list_stocks(_root, _args, %{context: %{is_admin: true}}) do
    {:ok, Stocks.list_stocks()}
  end

  # if not admin return error message
  def list_stocks(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

end
