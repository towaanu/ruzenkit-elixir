defmodule RuzenkitWeb.Graphql.StatsResolver do
  alias Ruzenkit.Stats
  alias RuzenkitWeb.Graphql.ResponseUtils
  # import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def list_stats_orders(_root, %{start_iso_date: start_iso_date, end_iso_date: end_iso_date}, %{
        context: %{is_admin: true}
      }) do
    {:ok, Stats.get_orders_for_date_range(start_iso_date, end_iso_date)}
  end

  def list_stats_orders(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}
end
