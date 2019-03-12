defmodule Ruzenkit.Stocks do
  @moduledoc """
  The Stocks context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Stocks.Stock
  alias Ruzenkit.Stocks.StockChange
  alias Ecto.Multi

  @doc """
  Returns the list of stocks.

  ## Examples

      iex> list_stocks()
      [%Stock{}, ...]

  """
  def list_stocks do
    Repo.all(Stock)
  end

  @doc """
  Gets a single stock.

  Raises `Ecto.NoResultsError` if the Stock does not exist.

  ## Examples

      iex> get_stock!(123)
      %Stock{}

      iex> get_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock!(id), do: Repo.get!(Stock, id)

  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_stock(attrs \\ %{}) do
  #   %Stock{}
  #   |> Stock.changeset(attrs)
  #   |> Repo.insert()
  # end

  defp new_stock_change(%{id: id, quantity: quantity}) do
    %StockChange{}
    |> StockChange.changeset(%{
      stock_id: id,
      new_quantity: quantity,
      operation: quantity,
      label: "INITIAL"
    })
  end

  def create_stock(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:stock, %Stock{} |> Stock.changeset(attrs))
    |> Multi.insert(:stock_change, fn %{stock: stock} -> new_stock_change(stock) end)
    |> Repo.transaction()
    |> case do
      {:ok, %{stock: stock, stock_change: _stock_change}} ->
        {:ok, stock}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %Stock{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def update_stock(%Stock{} = stock, attrs) do
  #   stock
  #   |> Stock.changeset(attrs)
  #   |> Repo.update()
  # end

  def update_stock(%{stock_id: stock_id, operation: operation, label: label}) do
    stock = Stock |> Repo.get!(stock_id)

    new_quantity = stock.quantity + operation

    Multi.new()
    |> Multi.update(:stock, Stock.changeset(stock, %{quantity: new_quantity}))
    |> Multi.insert(
      :stock_change,
      StockChange.changeset(%StockChange{}, %{
        stock_id: stock_id,
        operation: operation,
        label: label,
        new_quantity: new_quantity
      })
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{stock: stock, stock_change: _stock_change}} ->
        {:ok, stock}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  @doc """
  Deletes a Stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %Stock{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%Stock{} = stock) do
    Repo.delete(stock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock changes.

  ## Examples

      iex> change_stock(stock)
      %Ecto.Changeset{source: %Stock{}}

  """
  def change_stock(%Stock{} = stock) do
    Stock.changeset(stock, %{})
  end
end
