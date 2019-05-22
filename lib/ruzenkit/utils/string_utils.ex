defmodule Ruzenkit.Utils.StringUtils do
  def trim_and_downcase(_str = nil), do: nil

  def trim_and_downcase(str) do
    str
    |> String.trim()
    |> String.downcase()
  end

  def trim_and_upcase(_str = nil), do: nil

  def trim_and_upcase(str) do
    str
    |> String.trim()
    |> String.upcase()
  end

  def blank?(str_or_nil) do
    "" == str_or_nil |> to_string() |> String.trim()
  end
end
