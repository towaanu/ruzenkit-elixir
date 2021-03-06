defmodule Ruzenkit.Carts do
  @moduledoc """
  The Carts context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Carts.Cart
  alias Ruzenkit.Products
  alias Ruzenkit.Shippings

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

  defp gen_add_cart_item_params(%{id: id}, params) do
    params
    |> Map.delete(:sku)
    |> Map.put(:product_id, id)
  end

  # transform sku => product_id
  def add_cart_item(%{sku: sku} = params) do
    Products.Product
    |> Repo.get_by!(sku: sku)
    |> gen_add_cart_item_params(params)
    |> add_cart_item()
  end

  # When there is no cart yet but a user
  def add_cart_item(%{product_id: product_id, quantity: quantity, user_id: user_id, cart_id: nil}) do
    Multi.new()
    |> Multi.insert(
      :cart,
      %Cart{}
      |> Cart.changeset(%{user_id: user_id})
    )
    |> Multi.run(:cart_item, fn _repo, %{cart: %{id: cart_id}} ->
      add_cart_item(%{product_id: product_id, quantity: quantity, cart_id: cart_id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{cart_item: cart_item}} -> {:ok, cart_item}
      {:error, _failes_operation, failed_value} -> {:error, failed_value}
    end
  end

  # When there is no cart yet and no user
  def add_cart_item(%{product_id: product_id, quantity: quantity, cart_id: nil}) do
    Multi.new()
    |> Multi.insert(:cart, %Cart{})
    |> Multi.run(:cart_item, fn _repo, %{cart: %{id: cart_id}} ->
      add_cart_item(%{product_id: product_id, quantity: quantity, cart_id: cart_id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{cart_item: cart_item}} -> {:ok, cart_item}
      {:error, _failes_operation, failed_value} -> {:error, failed_value}
    end
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
            {:error, :parent_product_error}

          false ->
            create_cart_item(%{product_id: product_id, quantity: quantity, cart_id: cart_id})
        end

      # update_existing
      cart_item ->
        new_quantity = quantity + cart_item.quantity
        update_cart_item(cart_item, %{quantity: new_quantity})
    end
  end

  def add_configurable_item(
        cart_id,
        %{product_id: product_id, quantity: quantity},
        option_item_ids
      ) do
    case Products.get_child_product_by_options(product_id, option_item_ids) do
      nil ->
        {:no_product_found_error, "child product not found"}

      %{product: product} ->
        case cart_id do
          nil ->
            add_cart_item(%{product_id: product.id, quantity: quantity})

          _ ->
            add_cart_item(%{product_id: product.id, quantity: quantity, cart_id: cart_id})
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

  def delete_cart_item_by_id(id) do
    CartItem
    |> Repo.get!(id)
    |> Repo.delete()
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

  def total_price_for_cart(cart) do
    cart
    |> Repo.preload(cart_items: [product: :price])
    |> Map.get(:cart_items, [])
    |> Enum.map(&%{price_amount: &1.product.price.amount, quantity: &1.quantity})
    |> Enum.map(&Decimal.mult(&1.price_amount, &1.quantity))
    |> Enum.reduce(Decimal.new(0), &Decimal.add/2)
  end

  def total_price_for_cart_item(cart_item) do
    cart_item
    |> Repo.preload(product: :price)
    |> mult_quantity_and_price()
  end

  defp mult_quantity_and_price(%{quantity: quantity, product: %{price: %{amount: price_amount}}}) do
    Decimal.mult(price_amount, quantity)
  end

  def update_cart_address(cart_id, address) do
    Cart
    |> Repo.get!(cart_id)
    |> Repo.preload(:cart_shipping_information)
    |> Cart.changeset(%{cart_shipping_information: address})
    |> Repo.update()
  end

  def update_cart_address_and_email(cart_id, address, email) do
    IO.puts("HELLLOOOOO MAIL")

    Cart
    |> Repo.get!(cart_id)
    |> Repo.preload(:cart_shipping_information)
    |> Cart.changeset(%{cart_shipping_information: address, email: email})
    |> Repo.update()
  end

  def update_cart_shipping(cart_id, shipping_option_id) do
    Cart
    |> Repo.get!(cart_id)
    |> Repo.preload(:cart_shipping_information)
    |> Cart.changeset(%{cart_shipping_information: %{shipping_option_id: shipping_option_id}})
    |> Repo.update()
  end

  def find_shipping_options_for_cart(cart_id) do
    Cart
    |> Repo.get!(cart_id)
    |> Repo.preload(cart_shipping_information: :country)
    |> Map.get(:cart_shipping_information)
    |> Shippings.find_shipping_options_by_address()
  end
end
