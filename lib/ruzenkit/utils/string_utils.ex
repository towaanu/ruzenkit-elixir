defmodule Ruzenkit.Utils.StringUtils do

  def trim_and_downcase(str) do
    str
    |> String.trim()
    |> String.downcase()
  end

  def trim_and_upcase(str) do
    str
    |> String.trim()
    |> String.upcase()
  end


end
