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

  def create_country(_root, %{country: country_params}, %{context: %{is_admin: true}}) do
    case Addresses.create_country(country_params) do
      {:ok, country} ->
        {:ok, country}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new country", error)}
    end
  end

  def create_country(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def update_country(_root, %{id: id, country: country_params}, %{context: %{is_admin: true}}) do

    db_country = Addresses.get_country!(id)

    case Addresses.update_country(db_country, country_params) do
      {:ok, country} ->
        {:ok, country}

      error ->
        {:error, changeset_error_to_graphql("could not update country", error)}
    end
  end

  def update_country(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def get_country(_root, %{id: id}, _info) do
    case Addresses.get_country(id) do
      nil ->
        {:error, "country with id #{id} not found"}

      country ->
        {:ok, country}
    end
  end

  def list_countries(_root, _args, _info) do
    {:ok, Addresses.list_countries()}
  end
end
