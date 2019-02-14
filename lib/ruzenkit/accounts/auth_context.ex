defmodule Ruzenkit.Accounts.AuthContext do
  @behaviour Plug

  import Plug.Conn
  # import Ecto.Query, only: [where: 2]

  # alias Ruzenkit.{Repo, User}
  alias Ruzenkit.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    IO.puts("MIIIX #{Atom.to_string(Mix.env())}")
    case Mix.env() do
      :dev -> # in dev everyone is admin for simplicity
        with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
             {:ok, current_user} <- authorize(token) do
          %{current_user: current_user, auth_token: token, is_admin: true}
        else
          _ -> %{is_admin: true}
        end

      :prod ->
        with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
             {:ok, current_user} <- authorize(token) do
          %{current_user: current_user, auth_token: token, is_admin: current_user.is_admin}
        else
          _ -> %{}
        end
    end
  end

  defp authorize(token) do
    case Accounts.Guardian.resource_from_token(token) do
      {:ok, user, _claim} ->
        {:ok, user}

      {:error, _error} ->
        {:error, "token invalid"}
    end

    # User
    # |> where(token: ^token)
    # |> Repo.one()
    # |> case do
    #   nil -> {:error, "invalid authorization token"}
    #   user -> {:ok, user}
    # end
  end
end
