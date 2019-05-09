defmodule Ruzenkit.Shippings do
  @moduledoc """
  The Shippings context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Shippings.ShippingCarrier
  alias Ecto.Multi
  alias Ruzenkit.Addresses

  @doc """
  Returns the list of shipping_carriers.

  ## Examples

      iex> list_shipping_carriers()
      [%ShippingCarrier{}, ...]

  """
  def list_shipping_carriers do
    Repo.all(ShippingCarrier)
  end

  @doc """
  Gets a single shipping_carrier.

  Raises `Ecto.NoResultsError` if the Shipping carrier does not exist.

  ## Examples

      iex> get_shipping_carrier!(123)
      %ShippingCarrier{}

      iex> get_shipping_carrier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipping_carrier!(id), do: Repo.get!(ShippingCarrier, id)
  def get_shipping_carrier(id), do: Repo.get(ShippingCarrier, id)

  @doc """
  Creates a shipping_carrier.

  ## Examples

      iex> create_shipping_carrier(%{field: value})
      {:ok, %ShippingCarrier{}}

      iex> create_shipping_carrier(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shipping_carrier(attrs \\ %{}) do
    %ShippingCarrier{}
    |> ShippingCarrier.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shipping_carrier.

  ## Examples

      iex> update_shipping_carrier(shipping_carrier, %{field: new_value})
      {:ok, %ShippingCarrier{}}

      iex> update_shipping_carrier(shipping_carrier, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipping_carrier(%ShippingCarrier{} = shipping_carrier, attrs) do
    shipping_carrier
    |> ShippingCarrier.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ShippingCarrier.

  ## Examples

      iex> delete_shipping_carrier(shipping_carrier)
      {:ok, %ShippingCarrier{}}

      iex> delete_shipping_carrier(shipping_carrier)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipping_carrier(%ShippingCarrier{} = shipping_carrier) do
    Repo.delete(shipping_carrier)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipping_carrier changes.

  ## Examples

      iex> change_shipping_carrier(shipping_carrier)
      %Ecto.Changeset{source: %ShippingCarrier{}}

  """
  def change_shipping_carrier(%ShippingCarrier{} = shipping_carrier) do
    ShippingCarrier.changeset(shipping_carrier, %{})
  end

  alias Ruzenkit.Shippings.ShippingOption

  @doc """
  Returns the list of shipping_options.

  ## Examples

      iex> list_shipping_options()
      [%ShippingOption{}, ...]

  """
  def list_shipping_options do
    Repo.all(ShippingOption)
  end

  @doc """
  Gets a single shipping_option.

  Raises `Ecto.NoResultsError` if the Shipping option does not exist.

  ## Examples

      iex> get_shipping_option!(123)
      %ShippingOption{}

      iex> get_shipping_option!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipping_option!(id), do: Repo.get!(ShippingOption, id)
  def get_shipping_option(id), do: Repo.get(ShippingOption, id)

  @doc """
  Creates a shipping_option.

  ## Examples

      iex> create_shipping_option(%{field: value})
      {:ok, %ShippingOption{}}

      iex> create_shipping_option(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shipping_option(attrs \\ %{})

  def create_shipping_option(%{country_ids: country_ids} = attrs) do
    countries = Addresses.list_countries_by_ids(country_ids)

    shipping_option_changeset = %ShippingOption{} |> ShippingOption.changeset(attrs)

    result =
      Multi.new()
      |> Multi.insert(:shipping_option, shipping_option_changeset)
      |> Multi.update(:shipping_options_countries, fn %{shipping_option: shipping_option} ->
        shipping_option
        |> Repo.preload(:countries)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:countries, countries)
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{shipping_option: shipping_option}} ->
        {:ok, shipping_option}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
        # One of the operations failed. We can access the operation's failure
        # value (like changeset for operations on changesets) to prepare a
        # proper response. We also get access to the results of any operations
        # that succeeded before the indicated operation failed. However, any
        # successful operations would have been rolled back.
    end
  end

  def create_shipping_option(attrs) do
    %ShippingOption{}
    |> ShippingOption.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shipping_option.

  ## Examples

      iex> update_shipping_option(shipping_option, %{field: new_value})
      {:ok, %ShippingOption{}}

      iex> update_shipping_option(shipping_option, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipping_option(%ShippingOption{} = shipping_option, attrs) do
    shipping_option
    |> Repo.preload(:price)
    |> ShippingOption.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ShippingOption.

  ## Examples

      iex> delete_shipping_option(shipping_option)
      {:ok, %ShippingOption{}}

      iex> delete_shipping_option(shipping_option)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipping_option(%ShippingOption{} = shipping_option) do
    Repo.delete(shipping_option)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipping_option changes.

  ## Examples

      iex> change_shipping_option(shipping_option)
      %Ecto.Changeset{source: %ShippingOption{}}

  """
  def change_shipping_option(%ShippingOption{} = shipping_option) do
    ShippingOption.changeset(shipping_option, %{})
  end

  def find_shipping_options_by_address(%{country: %{id: country_id}}) do
    query =
      from so in ShippingOption,
        join: c in assoc(so, :countries),
        where: c.id == ^country_id

      Repo.all(query)
  end
end
