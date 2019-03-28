defmodule RuzenkitWeb.Graphql.OrdersResolver do
  alias Ruzenkit.Orders
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def create_order_status(_root, %{order_status: order_status}, %{context: %{is_admin: true}}) do
    case Orders.create_order_status(order_status) do
      {:ok, order_status} ->
        {:ok, order_status}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new order status", error)}
    end
  end

  def create_order_status(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def list_order_status(_root, _args, %{context: %{is_admin: true}}) do
    order_status = Orders.list_order_status()
    {:ok, order_status}
  end

  # if not admin return error message
  def list_order_status(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def list_orders(_root, _args, %{context: %{is_admin: true}}), do: {:ok, Orders.list_orders()}

  def list_orders(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def create_order_from_cart(_root, %{cart_id: cart_id, order: order_params}, _info) do
    case Orders.create_order_from_cart(cart_id, order_params) do
      {:ok, order} -> {:ok, order}
      {:error, error} -> {:error, changeset_error_to_graphql("Unable to create order", error)}
    end
  end

  def get_order_status(_root, %{id: id}, _info) do
    case Orders.get_order_status(id) do
      nil ->
        {:error, "order_status with id #{id} not found"}

      order_status ->
        {:ok, order_status}
    end
  end

  def update_order_status(_root, %{id: id, order_status: order_status_params}, %{
        context: %{is_admin: true}
      }) do
    db_order_status = Orders.get_order_status!(id)

    case Orders.update_order_status(db_order_status, order_status_params) do
      {:ok, order_status} ->
        {:ok, order_status}

      {:error, error} ->
        {:error, changeset_error_to_graphql("could not update order status", error)}
    end
  end

  def update_order_status(_root, _args, _info),
    do: {:error, ResponseUtils.unauthorized_response()}

  def change_order_status(_root, %{order_id: order_id, order_status_id: order_status_id}, %{context: %{is_admin: true}}) do
    case Orders.change_status_for_order(order_id, order_status_id) do
      {:ok, order} ->
        {:ok, order}

      {:error, error} ->
        {:error, changeset_error_to_graphql("could not change order status for order #{order_id}", error)}
    end
  end

  def change_order_status(_root, _args, _info),do: {:error, ResponseUtils.unauthorized_response()}

  # TODO: protect or not ?
  def get_order(_root, %{id: id}, _info) do
    case Orders.get_order(id) do
      nil ->
        {:error, "order with id #{id} not found"}

      order ->
        {:ok, order}
    end
  end

  def update_order(_root, %{order: order_params, id: id}, %{context: %{is_admin: true}}) do
    case Orders.update_order_by_id(id, order_params) do
      {:ok, order} ->
        {:ok, order}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to update order #{id}", error)}
    end
  end

  def update_order(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

end
