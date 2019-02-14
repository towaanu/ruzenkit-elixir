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

end
