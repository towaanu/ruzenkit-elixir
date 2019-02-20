defmodule RuzenkitWeb.Graphql.VatResolver do
  alias Ruzenkit.Vat
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def list_vat_groups(_root, _args, %{context: %{is_admin: true}}) do
    {:ok, Vat.list_vat_groups()}
  end

  def list_vat_groups(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def create_vat_group(_root, %{vat_group: vat_group}, %{
        context: %{is_admin: true}
      }) do
    case Vat.create_vat_group(vat_group) do
      {:ok, vat_group} ->
        {:ok, vat_group}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new vat group", error)}
    end
  end

  def create_vat_group(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}
end
