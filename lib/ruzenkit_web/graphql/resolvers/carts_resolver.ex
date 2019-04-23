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

  def add_to_cart(_root, %{cart_item: cart_item, option_item_ids: []}, _info),
    do: add_no_config_product_to_cart(cart_item)

  def add_to_cart(
        _root,
        %{cart_id: cart_id, cart_item: cart_item, option_item_ids: option_item_ids},
        _info
      ) do
    case Carts.add_configurable_item(cart_id, cart_item, option_item_ids) do
      {:ok, cart_item} ->
        {:ok, cart_item}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to add new cart item", error)}

      {:no_product_found_error, error_msg} ->
        {:error, error_msg}

      {:parent_product_error, error_msg} ->
        {:error, error_msg}
    end
  end

  def add_to_cart(_root, %{cart_item: cart_item}, _info),
    do: add_no_config_product_to_cart(cart_item)

  defp add_no_config_product_to_cart(cart_item) do
    case Carts.add_cart_item(cart_item) do
      {:ok, cart_item} ->
        {:ok, cart_item}

      {:parent_product_error, error_msg} ->
        {:error, error_msg}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create add new cart item", error)}
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
end
