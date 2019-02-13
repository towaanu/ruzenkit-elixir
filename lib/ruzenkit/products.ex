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
end
