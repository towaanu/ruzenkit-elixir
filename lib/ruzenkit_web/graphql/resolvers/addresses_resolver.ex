defmodule RuzenkitWeb.Graphql.AddressesResolver do
  alias Ruzenkit.Addresses
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  # if admin return addresses list
  def list_addresses(_root, _args, %{context: %{is_admin: true}}) do
    {:ok, Addresses.list_addresses()}
  end

  # if not admin return error message
  def list_addresses(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  # TODO: create address without user admin ?
  def create_address(_root, %{address: address}, _info) do
    case Addresses.create_address(address) do
      {:ok, address} ->
        {:ok, address}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new address", error)}
    end
  end
end
