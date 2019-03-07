defmodule Ruzenkit.Carts do
  @moduledoc """
  The Carts context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Carts.Cart
  alias Ruzenkit.Products

  alias Ecto.Multi

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)
  def get_cart(id), do: Repo.get(Cart, id)

  def get_cart_with_total(id) do
    Cart
    |> Repo.get!(id)
    |> Repo.preload(cart_items: [product: [price: :currency]])
    |> Cart.populate_total_price()
  end

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{source: %Cart{}}

  """
  def change_cart(%Cart{} = cart) do
    Cart.changeset(cart, %{})
  end

  alias Ruzenkit.Carts.CartItem

  @doc """
  Returns the list of cart_items.

  ## Examples

      iex> list_cart_items()
      [%CartItem{}, ...]

  """
  def list_cart_items do
    Repo.all(CartItem)
  end

  @doc """
  Gets a single cart_item.

  Raises `Ecto.NoResultsError` if the Cart item does not exist.

  ## Examples

      iex> get_cart_item!(123)
      %CartItem{}

      iex> get_cart_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart_item!(id), do: Repo.get!(CartItem, id)
  def get_cart_item(id), do: Repo.get(CartItem, id)

  @doc """
  Creates a cart_item.

  ## Examples

      iex> create_cart_item(%{field: value})
      {:ok, %CartItem{}}

      iex> create_cart_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart_item(attrs \\ %{}) do
    %CartItem{}
    |> CartItem.changeset(attrs)
    |> Repo.insert()
  end

  def add_cart_item(%{product_id: product_id, quantity: quantity, cart_id: cart_id}) do
    query =
      from ci in CartItem,
        where: ci.product_id == ^product_id and ci.cart_id == ^cart_id

    case Repo.one(query) do
      # new one
      nil ->
        case Products.is_parent_product(product_id) do
          true ->
            {:parent_product_error, "Can't add parent product"}

          false ->
            create_cart_item(%{product_id: product_id, quantity: quantity, cart_id: cart_id})
        end

      # update_existing
      cart_item ->
        new_quantity = quantity + cart_item.quantity
        update_cart_item(cart_item, %{quantity: new_quantity})
    end
  end

  # When there is no cart yet
  def add_cart_item(%{product_id: product_id, quantity: quantity}) do
    case Products.is_parent_product(product_id) do
      true ->
        {:parent_product_error, "Can't add parent product"}

      false ->
        result =
          Multi.new()
          |> Multi.insert(:cart, %Cart{})
          |> Multi.insert(:cart_item, fn %{cart: %{id: cart_id}} ->
            CartItem.changeset(%CartItem{}, %{
              product_id: product_id,
              quantity: quantity,
              cart_id: cart_id
            })
          end)
          |> Repo.transaction()

        case result do
          {:ok, %{cart: _cart, cart_item: cart_item}} -> {:ok, cart_item}
          {:error, _failed_operation, failed_value, _changes_so_far} -> {:error, failed_value}
        end
    end
  end

  def add_configurable_item(%{product_id: product_id} = cart_item, option_item_ids) do
    case Products.get_child_product_by_options(product_id, option_item_ids) do
      nil ->
        {:no_product_found_error, "child product not found"}

      %{product: product} ->
        case cart_item do
          %{quantity: quantity, cart_id: cart_id} ->
            add_cart_item(%{product_id: product.id, quantity: quantity, cart_id: cart_id})

          %{quantity: quantity} ->
            add_cart_item(%{product_id: product.id, quantity: quantity})
        end
    end
  end

  @doc """
  Updates a cart_item.

  ## Examples

      iex> update_cart_item(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CartItem.

  ## Examples

      iex> delete_cart_item(cart_item)
      {:ok, %CartItem{}}

      iex> delete_cart_item(cart_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart_item(%CartItem{} = cart_item) do
    Repo.delete(cart_item)
  end

  def remove_cart_item(%{product_id: product_id, quantity: quantity, cart_id: cart_id}) do
    query =
      from ci in CartItem,
        where: ci.product_id == ^product_id and ci.cart_id == ^cart_id

    case Repo.one(query) do
      # new one
      nil ->
        {:error, "Cart item {product_id: #{product_id}, cart_id #{cart_id} does not exist}"}

      # update_existing
      cart_item ->
        new_quantity = cart_item.quantity - quantity

        case new_quantity do
          qty when qty <= 0 ->
            # no more product
            delete_cart_item(cart_item)

          qty ->
            update_cart_item(cart_item, %{quantity: qty})
        end
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart_item changes.

  ## Examples

      iex> change_cart_item(cart_item)
      %Ecto.Changeset{source: %CartItem{}}

  """
  def change_cart_item(%CartItem{} = cart_item) do
    CartItem.changeset(cart_item, %{})
  end
end
