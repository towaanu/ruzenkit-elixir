defmodule RuzenkitWeb.Graphql.CartsResolver do
  alias Ruzenkit.Carts
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]


  def create_cart(_root, %{cart: cart}, %{context: %{current_user: current_user}}) do
    case Carts.create_cart(%{cart | user_id: current_user.id}) do
      {:ok, cart} ->
        {:ok, cart}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new cart", error)}
    end
  end

  def create_cart(_root, %{cart: cart}, _info) do
    case Carts.create_cart(cart) do
      {:ok, cart} ->
        {:ok, cart}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new cart", error)}
    end
  end

  def create_cart(_root, _args, _info) do
    case Carts.create_cart(%{}) do
      {:ok, cart} ->
        {:ok, cart}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new cart", error)}
    end
  end
end
