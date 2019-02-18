defmodule Ruzenkit.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  def get_product(id), do: Repo.get(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:price)
    |> Repo.insert()
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
    |> Product.changeset(attrs)
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
end
