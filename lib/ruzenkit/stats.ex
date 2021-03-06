NimbleCSV.define(CSVParser, separator: "\t", escape: "\"")

defmodule Ruzenkit.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo
  alias Ruzenkit.Orders.Order

  # defp compute_vat_amount(amount, rate) do
  #   (rate / 100)
  #   |> Decimal.from_float()
  #   |> Decimal.mult(amount)
  # end

  # Prix HT = Prix TTC / (1 + TVA)
  # Example 100 = 120 / 1.2 ( Prix TTC = 120, TVA : 20%)
  defp compute_vat_amount(amount, rate) do

    div_rate =
      rate
      |> Decimal.from_float()
      |> Decimal.div(100)
      |> Decimal.add(1)

    amount
    |> Decimal.div(div_rate)
    |> Decimal.round(2)
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

  defp find_key_by_tuple(tuple), do: tuple |> Tuple.to_list() |> Enum.at(0)

  defp sort_by_keys(keys_list, a, b) do
    a_order = Enum.find_index(keys_list, &(find_key_by_tuple(a) == &1))
    b_order = Enum.find_index(keys_list, &(find_key_by_tuple(b) == &1))
    a_order <= b_order
  end

  @csvs_dir "csvs"
  def orders_for_date_range_to_csv(start_iso_date, end_iso_date) do
    keys_list = [:id, :total, :vat_total_amount]

    content =
      [["id", "total", "tva"]]
      |> Enum.concat(
        get_orders_for_date_range(start_iso_date, end_iso_date)
        |> Enum.map(fn order ->
          order
          |> Map.take(keys_list)
          |> Map.to_list()
          |> Enum.sort(&sort_by_keys(keys_list, &1, &2))
          |> Enum.map(fn tuple -> tuple |> Tuple.to_list() |> Enum.at(1) end)
        end)
      )
      |> CSVParser.dump_to_iodata()

    Path.join([:code.priv_dir(:ruzenkit), @csvs_dir, "orders.csv"])
    |> File.write!(content)
  end
end
