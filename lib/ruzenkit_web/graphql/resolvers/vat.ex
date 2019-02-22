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

  def update_vat_group(_root, %{id: id, vat_group: vat_group_params}, %{context: %{is_admin: true}}) do

    db_vat_group = Vat.get_vat_group!(id)

    case Vat.update_vat_group(db_vat_group, vat_group_params) do
      {:ok, vat_group} ->
        {:ok, vat_group}

      {:error, error} ->
        {:error, changeset_error_to_graphql("could not update vat_group", error)}
    end
  end

  def update_vat_group(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def get_vat_group(_root, %{id: id}, _info) do
    case Vat.get_vat_group(id) do
      nil ->
        {:error, "vat_group with id #{id} not found"}

        vat_group ->
        {:ok, vat_group}
    end
  end

end
