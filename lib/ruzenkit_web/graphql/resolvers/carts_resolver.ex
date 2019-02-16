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

  # TODO: Think if, it needs to be protected or not ( only connected user or admin can access it ?)
  def get_cart(_root, %{id: id}, _info) do
    case Carts.get_cart(id) do
      nil ->
        {:error, "cart with id #{id} not found"}

      cart ->
        {:ok, cart}
    end
  end

  def add_to_cart(_root, %{cart_item: cart_item}, _info) do
    case Carts.add_cart_item(cart_item) do
      {:ok, cart_item} ->
        {:ok, cart_item}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create add new cart item", error)}
    end
  end
end
