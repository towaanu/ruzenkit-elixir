defmodule RuzenkitWeb.Graphql.CartsResolver do
  alias Ruzenkit.Carts
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def create_cart(_root, _args, %{context: %{current_user: current_user}}) do
    case Carts.create_cart(%{user_id: current_user.id}) do
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

  # def create_cart(_root, _args, _info) do
  #   case Carts.create_cart(%{}) do
  #     {:ok, cart} ->
  #       {:ok, cart}

  #     {:error, error} ->
  #       {:error, changeset_error_to_graphql("unable to create new cart", error)}
  #   end
  # end

  # TODO: Think if, it needs to be protected or not ( only connected user or admin can access it ?)
  def get_cart(_root, %{id: id}, _info) do
    case Carts.get_cart(id) do
      nil ->
        {:error, "cart with id #{id} not found"}

      cart ->
        {:ok, cart}
    end
  end

  def add_to_cart(root, %{cart_id: nil} = params, info) do
    new_params = Map.delete(params, :cart_id)
    add_to_cart(root, new_params, info)
  end

  def add_to_cart(_root, params, _info) do
    case Carts.add_cart_item(params) do
      {:ok, cart_item} ->
        {:ok, cart_item}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to add new cart item", error)}
    end
  end

  def update_cart_address(
        _root,
        %{cart_id: cart_id, cart_shipping_information_address: cart_address},
        _info
      ) do
    case Carts.update_cart_address(cart_id, cart_address) do
      {:ok, cart} ->
        {:ok, cart}

      {:error, error} ->
        {:error,
         changeset_error_to_graphql("unable to update address for cart #{cart_id}", error)}
    end
  end

  def update_cart_shipping(
        _root,
        %{cart_id: cart_id, shipping_option_id: shipping_option_id},
        _info
      ) do
    case Carts.update_cart_shipping(cart_id, shipping_option_id) do
      {:ok, cart} ->
        {:ok, cart}

      {:error, error} ->
        {:error,
         changeset_error_to_graphql("unable to update shipping for cart #{cart_id}", error)}
    end
  end

  def update_cart_item(_root, %{id: id, cart_item: cart_item_params}, _info) do
    Carts.get_cart_item!(id)
    |> Carts.update_cart_item(cart_item_params)
    |> case do
      {:ok, cart_item} ->
        {:ok, cart_item}

      {:error, error} ->
        {:error, changeset_error_to_graphql("could not update cart_item #{id}", error)}
    end
  end

  # TODO: Think if, it needs to be protected or not ( only connected user or admin can access it ?)
  def delete_cart_item(_root, %{id: id}, _info) do
    case Carts.delete_cart_item_by_id(id) do
      {:ok, cart_item} -> {:ok, cart_item}
      {:error, error} -> {:error, changeset_error_to_graphql("unable to delete cart item", error)}
    end
  end

  def remove_cart_item(_root, %{cart_item: cart_item}, _info) do
    case Carts.remove_cart_item(cart_item) do
      {:ok, cart_item} -> {:ok, cart_item}
      {:error, error} -> {:error, changeset_error_to_graphql("unable to remove cart item", error)}
    end
  end

  def find_shipping_options_for_cart(_root, %{cart_id: cart_id}, _info) do
    {:ok, Carts.find_shipping_options_for_cart(cart_id)}
  end
end
