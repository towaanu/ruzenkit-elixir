defmodule Ruzenkit.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Products.Product
  alias Ruzenkit.Products.ParentProduct
  alias Ruzenkit.Products.ChildProduct
  alias Ecto.Multi
  alias Ruzenkit.Stocks

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  def list_root_products do

    child_product_product_ids_query = from cp in ChildProduct, select: cp.product_id
    child_product_product_ids = Repo.all(child_product_product_ids_query)

    root_products_query =
      from product in Product,
      where: product.id not in ^child_product_product_ids

      root_products_query
      |> Repo.all()
  end

  # def list_parent_products do
  #   parent_product_query =
  #     from parent_product in ParentProduct,
  #       select: parent_product.product_id

  #   parent_product_ids = Repo.all(parent_product_query)

  #   query =
  #     from product in Product,
  #       where: product.id in ^parent_product_ids

  #   Repo.all(query)
  # end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Repo.get!(Product, id)
    |> Repo.preload(:price)
  end

  def get_product(id), do: Repo.get(Product, id)


  # def create_product(attrs \\ %{}) do
  #   %Product{}
  #   |> Product.changeset(attrs)
  #   |> Ecto.Changeset.cast_assoc(:price)
  #   |> Ecto.Changeset.cast_assoc(:parent_product)
  #   |> Ecto.Changeset.cast_assoc(:child_product)
  #   |> Repo.insert()
  # end

  defp get_attrs_stock(%{stock: attrs_stock}), do: attrs_stock
  defp get_attrs_stock(_attrs), do: %{}

  defp new_product(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:price)
    |> Ecto.Changeset.cast_assoc(:parent_product)
    |> Ecto.Changeset.cast_assoc(:child_product)
  end

  def create_product(attrs \\ %{}) do

    attrs_stock = get_attrs_stock(attrs)

    Multi.new()
    |> Multi.insert(:product, new_product(attrs))
    |> Multi.run(:stock, fn _repo, %{product: %{id: product_id}} ->
      Stocks.create_stock(Map.put(attrs_stock, :product_id, product_id))
      # Stocks.create_stock(%{attrs_stock | product_id: product_id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{product: product}} ->
        {:ok, product}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end

  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Repo.preload([:price, [parent_product: :configurable_options], :child_product])
    |> Product.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:price)
    |> Ecto.Changeset.cast_assoc(:parent_product)
    |> Ecto.Changeset.cast_assoc(:child_product)
    |> Repo.update()
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias Ruzenkit.Products.ConfigurableOption

  @doc """
  Returns the list of configurable_options.

  ## Examples

      iex> list_configurable_options()
      [%ConfigurableOption{}, ...]

  """
  def list_configurable_options do
    Repo.all(ConfigurableOption)
  end

  @doc """
  Gets a single configurable_option.

  Raises `Ecto.NoResultsError` if the Configurable option does not exist.

  ## Examples

      iex> get_configurable_option!(123)
      %ConfigurableOption{}

      iex> get_configurable_option!(456)
      ** (Ecto.NoResultsError)

  """
  def get_configurable_option!(id), do: Repo.get!(ConfigurableOption, id)
  def get_configurable_option(id), do: Repo.get(ConfigurableOption, id)

  @doc """
  Creates a configurable_option.

  ## Examples

      iex> create_configurable_option(%{field: value})
      {:ok, %ConfigurableOption{}}

      iex> create_configurable_option(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_configurable_option(attrs \\ %{}) do
    %ConfigurableOption{}
    |> ConfigurableOption.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a configurable_option.

  ## Examples

      iex> update_configurable_option(configurable_option, %{field: new_value})
      {:ok, %ConfigurableOption{}}

      iex> update_configurable_option(configurable_option, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_configurable_option(%ConfigurableOption{} = configurable_option, attrs) do
    configurable_option
    |> ConfigurableOption.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ConfigurableOption.

  ## Examples

      iex> delete_configurable_option(configurable_option)
      {:ok, %ConfigurableOption{}}

      iex> delete_configurable_option(configurable_option)
      {:error, %Ecto.Changeset{}}

  """
  def delete_configurable_option(%ConfigurableOption{} = configurable_option) do
    Repo.delete(configurable_option)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking configurable_option changes.

  ## Examples

      iex> change_configurable_option(configurable_option)
      %Ecto.Changeset{source: %ConfigurableOption{}}

  """
  def change_configurable_option(%ConfigurableOption{} = configurable_option) do
    ConfigurableOption.changeset(configurable_option, %{})
  end

  def link_product_configurable_options(product_id, configurable_option_id) do
    product = Product |> Repo.get!(product_id)
    configurable_option = ConfigurableOption |> Repo.get!(configurable_option_id)

    product
    |> Repo.preload(:configurable_options)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:configurable_options, [configurable_option])
    |> Repo.update()
  end

  alias Ruzenkit.Products.ConfigurableProduct

  @doc """
  Returns the list of configurable_products.

  ## Examples

      iex> list_configurable_products()
      [%ConfigurableProduct{}, ...]

  """
  def list_configurable_products do
    Repo.all(ConfigurableProduct)
  end

  @doc """
  Gets a single configurable_product.

  Raises `Ecto.NoResultsError` if the Configurable product does not exist.

  ## Examples

      iex> get_configurable_product!(123)
      %ConfigurableProduct{}

      iex> get_configurable_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_configurable_product!(id), do: Repo.get!(ConfigurableProduct, id)

  @doc """
  Creates a configurable_product.

  ## Examples

      iex> create_configurable_product(%{field: value})
      {:ok, %ConfigurableProduct{}}

      iex> create_configurable_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_configurable_product(attrs \\ %{}) do
    %ConfigurableProduct{}
    |> ConfigurableProduct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a configurable_product.

  ## Examples

      iex> update_configurable_product(configurable_product, %{field: new_value})
      {:ok, %ConfigurableProduct{}}

      iex> update_configurable_product(configurable_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_configurable_product(%ConfigurableProduct{} = configurable_product, attrs) do
    configurable_product
    |> ConfigurableProduct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ConfigurableProduct.

  ## Examples

      iex> delete_configurable_product(configurable_product)
      {:ok, %ConfigurableProduct{}}

      iex> delete_configurable_product(configurable_product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_configurable_product(%ConfigurableProduct{} = configurable_product) do
    Repo.delete(configurable_product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking configurable_product changes.

  ## Examples

      iex> change_configurable_product(configurable_product)
      %Ecto.Changeset{source: %ConfigurableProduct{}}

  """
  def change_configurable_product(%ConfigurableProduct{} = configurable_product) do
    ConfigurableProduct.changeset(configurable_product, %{})
  end

  alias Ruzenkit.Products.ConfigurableItemOption

  @doc """
  Returns the list of configurable_item_options.

  ## Examples

      iex> list_configurable_item_options()
      [%ConfigurableItemOption{}, ...]

  """
  def list_configurable_item_options do
    Repo.all(ConfigurableItemOption)
  end

  @doc """
  Gets a single configurable_item_option.

  Raises `Ecto.NoResultsError` if the Configurable item option does not exist.

  ## Examples

      iex> get_configurable_item_option!(123)
      %ConfigurableItemOption{}

      iex> get_configurable_item_option!(456)
      ** (Ecto.NoResultsError)

  """
  def get_configurable_item_option!(id), do: Repo.get!(ConfigurableItemOption, id)
  def get_configurable_item_option(id), do: Repo.get!(ConfigurableItemOption, id)

  def get_configurable_item_options_by_co(id) do
    query =
      from cio in ConfigurableItemOption,
        where: cio.configurable_option_id == ^id

    Repo.all(query)
  end

  @doc """
  Creates a configurable_item_option.

  ## Examples

      iex> create_configurable_item_option(%{field: value})
      {:ok, %ConfigurableItemOption{}}

      iex> create_configurable_item_option(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_configurable_item_option(attrs \\ %{}) do
    %ConfigurableItemOption{}
    |> ConfigurableItemOption.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a configurable_item_option.

  ## Examples

      iex> update_configurable_item_option(configurable_item_option, %{field: new_value})
      {:ok, %ConfigurableItemOption{}}

      iex> update_configurable_item_option(configurable_item_option, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_configurable_item_option(%ConfigurableItemOption{} = configurable_item_option, attrs) do
    configurable_item_option
    |> ConfigurableItemOption.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ConfigurableItemOption.

  ## Examples

      iex> delete_configurable_item_option(configurable_item_option)
      {:ok, %ConfigurableItemOption{}}

      iex> delete_configurable_item_option(configurable_item_option)
      {:error, %Ecto.Changeset{}}

  """
  def delete_configurable_item_option(%ConfigurableItemOption{} = configurable_item_option) do
    Repo.delete(configurable_item_option)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking configurable_item_option changes.

  ## Examples

      iex> change_configurable_item_option(configurable_item_option)
      %Ecto.Changeset{source: %ConfigurableItemOption{}}

  """
  def change_configurable_item_option(%ConfigurableItemOption{} = configurable_item_option) do
    ConfigurableItemOption.changeset(configurable_item_option, %{})
  end

  alias Ruzenkit.Products.ProductPrice

  @doc """
  Returns the list of product_prices.

  ## Examples

      iex> list_product_prices()
      [%ProductPrice{}, ...]

  """
  def list_product_prices do
    Repo.all(ProductPrice)
  end

  @doc """
  Gets a single product_price.

  Raises `Ecto.NoResultsError` if the Product price does not exist.

  ## Examples

      iex> get_product_price!(123)
      %ProductPrice{}

      iex> get_product_price!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_price!(id), do: Repo.get!(ProductPrice, id)

  @doc """
  Creates a product_price.

  ## Examples

      iex> create_product_price(%{field: value})
      {:ok, %ProductPrice{}}

      iex> create_product_price(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_price(attrs \\ %{}) do
    %ProductPrice{}
    |> ProductPrice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_price.

  ## Examples

      iex> update_product_price(product_price, %{field: new_value})
      {:ok, %ProductPrice{}}

      iex> update_product_price(product_price, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_price(%ProductPrice{} = product_price, attrs) do
    product_price
    |> ProductPrice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProductPrice.

  ## Examples

      iex> delete_product_price(product_price)
      {:ok, %ProductPrice{}}

      iex> delete_product_price(product_price)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_price(%ProductPrice{} = product_price) do
    Repo.delete(product_price)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_price changes.

  ## Examples

      iex> change_product_price(product_price)
      %Ecto.Changeset{source: %ProductPrice{}}

  """
  def change_product_price(%ProductPrice{} = product_price) do
    ProductPrice.changeset(product_price, %{})
  end

  alias Ruzenkit.Products.ParentProduct

  @doc """
  Returns the list of parent_products.

  ## Examples

      iex> list_parent_products()
      [%ParentProduct{}, ...]

  """
  def list_parent_products do
    Repo.all(ParentProduct)
  end

  @doc """
  Gets a single parent_product.

  Raises `Ecto.NoResultsError` if the Parent product does not exist.

  ## Examples

      iex> get_parent_product!(123)
      %ParentProduct{}

      iex> get_parent_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parent_product!(id), do: Repo.get!(ParentProduct, id)
  def get_parent_product(id), do: Repo.get(ParentProduct, id)

  def is_parent_product(product_id) do
    query =
      from pp in ParentProduct,
      where: pp.product_id == ^product_id

    case Repo.one(query) do
      nil -> false
      _parent_product -> true
    end

  end

  @doc """
  Creates a parent_product.

  ## Examples

      iex> create_parent_product(%{field: value})
      {:ok, %ParentProduct{}}

      iex> create_parent_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parent_product(attrs \\ %{}) do
    %ParentProduct{}
    |> ParentProduct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parent_product.

  ## Examples

      iex> update_parent_product(parent_product, %{field: new_value})
      {:ok, %ParentProduct{}}

      iex> update_parent_product(parent_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parent_product(%ParentProduct{} = parent_product, attrs) do
    parent_product
    |> ParentProduct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ParentProduct.

  ## Examples

      iex> delete_parent_product(parent_product)
      {:ok, %ParentProduct{}}

      iex> delete_parent_product(parent_product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parent_product(%ParentProduct{} = parent_product) do
    Repo.delete(parent_product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parent_product changes.

  ## Examples

      iex> change_parent_product(parent_product)
      %Ecto.Changeset{source: %ParentProduct{}}

  """
  def change_parent_product(%ParentProduct{} = parent_product) do
    ParentProduct.changeset(parent_product, %{})
  end

  alias Ruzenkit.Products.ChildProduct

  @doc """
  Returns the list of child_products.

  ## Examples

      iex> list_child_products()
      [%ChildProduct{}, ...]

  """
  def list_child_products do
    Repo.all(ChildProduct)
  end

  @doc """
  Gets a single child_product.

  Raises `Ecto.NoResultsError` if the Child product does not exist.

  ## Examples

      iex> get_child_product!(123)
      %ChildProduct{}

      iex> get_child_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_child_product!(id), do: Repo.get!(ChildProduct, id)

  defp strings_to_integer(str_value) when is_bitstring(str_value),
    do: String.to_integer(str_value)

  defp strings_to_integer(int_value) when is_integer(int_value), do: int_value

  def get_child_product_by_options(parent_id, option_item_ids) do
    integer_option_item_ids = Enum.map(option_item_ids, &strings_to_integer/1)

    product =
      Repo.get(Product, parent_id)
      |> Repo.preload(parent_product: [child_products: [:product, :configurable_item_options]])

    child_products = product.parent_product.child_products

    res =
      Enum.find(child_products, fn %{configurable_item_options: configurable_item_options} ->
        cp_item_option_ids =
          configurable_item_options
          |> Enum.map(& &1.id)

        Enum.sort(integer_option_item_ids) == Enum.sort(cp_item_option_ids)
      end)

    res
  end

  @doc """
  Creates a child_product.

  ## Examples

      iex> create_child_product(%{field: value})
      {:ok, %ChildProduct{}}

      iex> create_child_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_child_product(attrs \\ %{}) do
    %ChildProduct{}
    |> ChildProduct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a child_product.

  ## Examples

      iex> update_child_product(child_product, %{field: new_value})
      {:ok, %ChildProduct{}}

      iex> update_child_product(child_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_child_product(%ChildProduct{} = child_product, attrs) do
    child_product
    |> ChildProduct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ChildProduct.

  ## Examples

      iex> delete_child_product(child_product)
      {:ok, %ChildProduct{}}

      iex> delete_child_product(child_product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_child_product(%ChildProduct{} = child_product) do
    Repo.delete(child_product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking child_product changes.

  ## Examples

      iex> change_child_product(child_product)
      %Ecto.Changeset{source: %ChildProduct{}}

  """
  def change_child_product(%ChildProduct{} = child_product) do
    ChildProduct.changeset(child_product, %{})
  end
end
