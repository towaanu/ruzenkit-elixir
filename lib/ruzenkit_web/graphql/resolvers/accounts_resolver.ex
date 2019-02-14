defmodule RuzenkitWeb.Graphql.AccountsResolver do
  alias Ruzenkit.Accounts
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  def list_users(_root, _args, _info) do
    users = Accounts.list_users()
    {:ok, users}
  end

  def create_user(_root, %{user: user}, _info) do
    case Accounts.create_user(user) do
      {:ok, user} ->
        {:ok, user}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new user", error)}
    end
  end

  def get_user(_root, %{id: id}, _info) do
    case Accounts.get_user(id) do
      nil ->
        {:error, "user with id #{id} not found"}

      user ->
        {:ok, user}
    end
  end

  def login(_root, %{email: email, password: password}, _info) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         {:ok, token, _claim} <- Accounts.Guardian.encode_and_sign(user) do
      {:ok, token}
    else
      {:error, _} -> {:error, "Failed to login"}
    end
  end

  def logout(_root, _args, %{context: %{auth_token: auth_token}}) do
    case Accounts.revoke_auth_token(auth_token) do
      {:ok, _claim} -> {:ok, true}
      {:error, _error} -> {:error, "Unable to logout"}
    end
  end

  # He is not logged in
  def logout(_root, _args, _info), do: {:ok, true}

  def me(_root, _args, %{context: %{current_user: current_user}}) do
    {:ok, "Hello #{current_user.first_name} :D"}
  end

  def me(_root, _args, _info), do: {:ok, "I don't know you :("}
end
