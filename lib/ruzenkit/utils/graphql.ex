defmodule Ruzenkit.Utils.Graphql do

  def changeset_error_to_graphql(message, changeset = %Ecto.Changeset{}) do

    details = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

    messages = details
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> "#{key} #{value}" end)

    %{message: message, details: details, messages: messages}
  end


end
