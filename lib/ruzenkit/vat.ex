defmodule Ruzenkit.Vat do
  @moduledoc """
  The Vat context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Vat.VatGroup

  @doc """
  Returns the list of vat_groups.

  ## Examples

      iex> list_vat_groups()
      [%VatGroup{}, ...]

  """
  def list_vat_groups do
    Repo.all(VatGroup)
  end

  @doc """
  Gets a single vat_group.

  Raises `Ecto.NoResultsError` if the Vat group does not exist.

  ## Examples

      iex> get_vat_group!(123)
      %VatGroup{}

      iex> get_vat_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vat_group!(id), do: Repo.get!(VatGroup, id)
  def get_vat_group(id), do: Repo.get(VatGroup, id)

  @doc """
  Creates a vat_group.

  ## Examples

      iex> create_vat_group(%{field: value})
      {:ok, %VatGroup{}}

      iex> create_vat_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vat_group(attrs \\ %{}) do
    %VatGroup{}
    |> VatGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vat_group.

  ## Examples

      iex> update_vat_group(vat_group, %{field: new_value})
      {:ok, %VatGroup{}}

      iex> update_vat_group(vat_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vat_group(%VatGroup{} = vat_group, attrs) do
    IO.inspect(attrs)
    vat_group
    |> VatGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a VatGroup.

  ## Examples

      iex> delete_vat_group(vat_group)
      {:ok, %VatGroup{}}

      iex> delete_vat_group(vat_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vat_group(%VatGroup{} = vat_group) do
    Repo.delete(vat_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vat_group changes.

  ## Examples

      iex> change_vat_group(vat_group)
      %Ecto.Changeset{source: %VatGroup{}}

  """
  def change_vat_group(%VatGroup{} = vat_group) do
    VatGroup.changeset(vat_group, %{})
  end
end
