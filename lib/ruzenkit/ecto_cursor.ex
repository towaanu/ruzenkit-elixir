defmodule Ruzenkit.EctoCursor do
  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  defp encode_cursor(cursor) do
    cursor
    |> Jason.encode!()
    |> Base.encode64()
  end

  defp decode_cursor(cursor) do
    cursor
    |> Base.decode64!()
    |> Jason.decode!(keys: :atoms)
  end

  def query_with_cursor(query, limit) do
    query_with_cursor(query, limit, %{cursor_id: 0}, :forward)
  end

  def query_with_cursor(query, limit, cursor, direction) when is_binary(cursor) do
    map_cursor = decode_cursor(cursor)
    query_with_cursor(query, limit, map_cursor, direction)
  end

  def query_with_cursor(query, limit, %{cursor_id: cursor_id}, :forward) do
    total_rows = Repo.aggregate(query, :count, :id)

    res =
      query
      |> where([item], item.id > ^cursor_id)
      |> limit(^limit)
      |> Repo.all()

    next_cursor_id =
      res
      |> List.last()
      |> case do
        nil -> nil
        %{id: id} -> id
      end

    cursor_info = %{
      total_rows: total_rows
    }

    new_cursor =
      encode_cursor(%{
        previous_cursor_id: cursor_id + 1,
        cursor_id: next_cursor_id
      })

    {res, new_cursor, cursor_info}
  end

  def query_with_cursor(query, limit, %{previous_cursor_id: previous_cursor_id}, :backward) do
    total_rows = Repo.aggregate(query, :count, :id)

    res =
      query
      |> where([item], item.id < ^previous_cursor_id)
      |> limit(^limit)
      |> reverse_order()
      |> Repo.all()
      |> Enum.reverse()

    next_previous_cursor_id =
      res
      |> List.first()
      |> case do
        nil -> nil
        %{id: id} -> id
      end

    cursor_info = %{
      total_rows: total_rows
    }

    new_cursor =
      encode_cursor(%{
        previous_cursor_id: next_previous_cursor_id,
        cursor_id: previous_cursor_id - 1
      })

    {res, new_cursor, cursor_info}
  end

  # by default go forward
  def query_with_cursor(query, limit, cursor, _direction),
    do: query_with_cursor(query, limit, cursor, :forward)
end
