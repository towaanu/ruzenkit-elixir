defmodule Ruzenkit.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo
  alias Ruzenkit.Orders.Order

  defp compute_vat_amount(amount, rate) do
    (rate / 100)
    |> Decimal.from_float()
    |> Decimal.mult(amount)
  end

  defp compute_vat_total_amount(order_items) do
    order_items
    |> Enum.reduce(Decimal.new(0), fn %{
                                        vat_rate: vat_rate,
                                        price_amount: price_amount,
                                        quantity: quantity
                                      },
                                      total ->
      compute_vat_amount(price_amount, vat_rate)
      |> Decimal.mult(quantity)
      |> Decimal.add(total)
    end)
  end

  def populate_vat_amount_order_item(
        %{vat_rate: vat_rate, price_amount: price_amount, quantity: quantity} = order_item
      ) do
    order_item
    |> Map.put_new(
      :vat_total_amount,
      compute_vat_amount(price_amount, vat_rate) |> Decimal.mult(quantity)
    )
  end

  defp populate_vat_total_amount(%{order_items: order_items} = order) do
    order
    |> Map.put_new(:vat_total_amount, compute_vat_total_amount(order_items))
  end

  defp add_vat_amount_to_order_items(%{order_items: order_items} = order) do
    order
    |> Map.put(:order_items, Enum.map(order_items, &populate_vat_amount_order_item/1))
  end

  def get_orders_for_date_range(start_iso_date, end_iso_date) do
    with {:ok, start_date, _} <- DateTime.from_iso8601(start_iso_date),
         {:ok, end_date, _} <- DateTime.from_iso8601(end_iso_date) do
      order_query =
        from o in Order,
          where: o.inserted_at >= ^start_date,
          where: o.inserted_at <= ^end_date

      order_query
      |> Repo.all()
      |> Repo.preload(:order_items)
      |> Enum.map(&add_vat_amount_to_order_items/1)
      |> Enum.map(&populate_vat_total_amount/1)
    end
  end
end
