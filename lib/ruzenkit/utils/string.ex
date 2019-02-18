defmodule Ruzenkit.Utils.String do

  def trim_and_downcase(str) do
    str
    |> String.trim()
    |> String.downcase()
  end


end
