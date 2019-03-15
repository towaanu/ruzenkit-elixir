defmodule Ruzenkit.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Orders.Order
  alias Ruzenkit.Orders.OrderStatus
  alias Ruzenkit.Carts
  alias Ruzenkit.Orders.OrderItem
  alias Ruzenkit.Stocks
  alias Ecto.Multi

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)
  def get_order(id), do: Repo.get(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  defp send_order_mail(order = %Order{}) do
    %{user: %{profile: %{email: email}}} = Repo.preload(order, user: :profile)

    Ruzenkit.Email.order_email(email: email) |> Ruzenkit.Mailer.deliver_now()
  end

  defp remove_products_stock(%{cart_items: cart_items}) do
    cart_items
    |> Enum.map(fn %{quantity: quantity, product_id: product_id} ->
      Stocks.remove_product_stock(product_id, quantity)
    end)
    |> Enum.find(fn res ->
      case res do
        {:ok, _value} -> false
        {:error, _error} -> true
      end
    end)
    |> case do
      nil -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end

  def create_order_from_cart(cart_id, order_address) do
    %{id: status_id} = Repo.get_by!(OrderStatus, is_default: true)

    cart = Carts.get_cart_with_total(cart_id)
    order_items = Enum.map(cart.cart_items, &cart_item_to_order_item/1)

    new_order_attrs = %{
      total: cart.total_price,
      user_id: cart.user_id,
      order_status_id: status_id,
      order_items: order_items,
      order_address: order_address
    }

    new_order_changeset =
      %Order{}
      |> Order.changeset(new_order_attrs)
      |> Ecto.Changeset.cast_assoc(:order_items)

    res =
      Multi.new()
      |> Multi.insert(:order, new_order_changeset)
      |> Multi.run(:remove_stock, fn _repo, _changes -> remove_products_stock(cart) end)
      |> Multi.run(:delete_cart, fn _repo, _changes ->
        Carts.delete_cart(cart)
      end)
      |> Repo.transaction()

    case res do
      {:ok, %{order: order}} ->
        send_order_mail(order)
        {:ok, order}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  defp cart_item_to_order_item(%Carts.CartItem{
         quantity: quantity,
         product: %{id: product_id, price: %{amount: amount, currency: %{code: code, sign: sign}}}
       }) do
    %{
      quantity: quantity,
      price_amount: amount,
      price_currency_code: code,
      price_currency_sign: sign,
      product_id: product_id
    }
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end

  # alias Ruzenkit.Orders.OrderItem

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItem)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderItem.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_order_item(order_item)
      %Ecto.Changeset{source: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item) do
    OrderItem.changeset(order_item, %{})
  end

  @doc """
  Returns the list of order_status.

  ## Examples

      iex> list_order_status()
      [%OrderStatus{}, ...]

  """
  def list_order_status do
    Repo.all(OrderStatus)
  end

  @doc """
  Gets a single order_status.

  Raises `Ecto.NoResultsError` if the Order status does not exist.

  ## Examples

      iex> get_order_status!(123)
      %OrderStatus{}

      iex> get_order_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_status!(id), do: Repo.get!(OrderStatus, id)
  def get_order_status(id), do: Repo.get(OrderStatus, id)

  # remove old status from being default and add the new one
  defp insert_and_remove_default_order_status(default_order_status, %{is_default: true} = attrs) do
    Multi.new()
    |> Multi.update(
      :update_default,
      Ecto.Changeset.change(default_order_status, is_default: false)
    )
    |> Multi.insert(
      :insert_order_status,
      OrderStatus.changeset(%OrderStatus{}, attrs)
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{insert_order_status: order_status}} ->
        {:ok, order_status}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  defp insert_and_remove_default_order_status(_default_order_status, attrs) do
    %OrderStatus{}
    |> OrderStatus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a order_status.

  ## Examples

      iex> create_order_status(%{field: value})
      {:ok, %OrderStatus{}}

      iex> create_order_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_status(attrs \\ %{}) do
    case Repo.get_by(OrderStatus, is_default: true) do
      # if no default, it's default
      nil ->
        %OrderStatus{}
        |> OrderStatus.changeset(Map.put(attrs, :is_default, true))
        # |> OrderStatus.changeset(%{attrs | is_default: true})
        |> Repo.insert()

      default_order_status ->
        insert_and_remove_default_order_status(default_order_status, attrs)
    end
  end

  @doc """
  Updates a order_status.

  ## Examples

      iex> update_order_status(order_status, %{field: new_value})
      {:ok, %OrderStatus{}}

      iex> update_order_status(order_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_status(
        %OrderStatus{is_default: false} = order_status,
        %{is_default: true} = attrs
      ) do
    Multi.new()
    |> Multi.update(
      :update_default,
      OrderStatus |> Repo.get_by!(is_default: true) |> Ecto.Changeset.change(is_default: false)
    )
    |> Multi.update(
      :update_order_status,
      OrderStatus.changeset(order_status, attrs)
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{update_order_status: order_status}} ->
        {:ok, order_status}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  def update_order_status(%OrderStatus{} = order_status, attrs) do
    order_status
    |> OrderStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderStatus.

  ## Examples

      iex> delete_order_status(order_status)
      {:ok, %OrderStatus{}}

      iex> delete_order_status(order_status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_status(%OrderStatus{} = order_status) do
    Repo.delete(order_status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_status changes.

  ## Examples

      iex> change_order_status(order_status)
      %Ecto.Changeset{source: %OrderStatus{}}

  """
  def change_order_status(%OrderStatus{} = order_status) do
    OrderStatus.changeset(order_status, %{})
  end

  def change_status_for_order(order_id, new_order_status_id) do
    order = Repo.get!(Order, order_id)

    order
    |> Order.change_status_changeset(%{order_status_id: new_order_status_id})
    |> Repo.update()
  end
end
