defmodule RuzenkitWeb.Graphql.ShippingsResolver do
  alias Ruzenkit.Shippings
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def list_shipping_carriers(_root, _args, %{context: %{is_admin: true}}) do
    {:ok, Shippings.list_shipping_carriers()}
  end

  def list_shipping_carriers(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def create_shipping_carrier(_root, %{shipping_carrier: shipping_carrier}, %{
        context: %{is_admin: true}
      }) do
    case Shippings.create_shipping_carrier(shipping_carrier) do
      {:ok, shipping_carrier} ->
        {:ok, shipping_carrier}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new shipping carrier", error)}
    end
  end

  def create_shipping_carrier(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def list_shipping_options(_root, _args, %{context: %{is_admin: true}}) do
    {:ok, Shippings.list_shipping_options()}
  end

  def list_shipping_options(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def create_shipping_option(_root, %{shipping_option: shipping_option}, %{
        context: %{is_admin: true}
      }) do
    case Shippings.create_shipping_option(shipping_option) do
      {:ok, shipping_option} ->
        {:ok, shipping_option}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new shipping option", error)}
    end
  end

  def create_shipping_options(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def get_shipping_carrier(_root, %{id: id}, _info) do
    case Shippings.get_shipping_carrier(id) do
      nil ->
        {:error, "shipping carrier with id #{id} not found"}

        shipping_carrier ->
        {:ok, shipping_carrier}
    end
  end

  def update_shipping_carrier(_root, %{id: id, shipping_carrier: shipping_carrier_params}, %{context: %{is_admin: true}}) do

    db_shipping_carrier = Shippings.get_shipping_carrier!(id)

    case Shippings.update_shipping_carrier(db_shipping_carrier, shipping_carrier_params) do
      {:ok, shipping_carrier} ->
        {:ok, shipping_carrier}

      {:error, error} ->
        {:error, changeset_error_to_graphql("could not update shipping carrier", error)}
    end
  end

  def update_shipping_carrier(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

end
