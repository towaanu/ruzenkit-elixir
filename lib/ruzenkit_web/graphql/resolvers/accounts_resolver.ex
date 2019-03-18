defmodule RuzenkitWeb.Graphql.AccountsResolver do
  alias Ruzenkit.Accounts
  alias RuzenkitWeb.Graphql.ResponseUtils
  import Ruzenkit.Utils.Graphql, only: [changeset_error_to_graphql: 2]

  # if admin return users list
  def list_users(_root, _args, %{context: %{is_admin: true}}) do
    users = Accounts.list_users()
    {:ok, users}
  end

  # if not admin return error message
  def list_users(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def create_user(_root, %{user: user}, _info) do
    IO.inspect(user)
    case Accounts.create_user(user) do
      {:ok, user} ->
        {:ok, user}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new user", error)}
    end
  end

  def create_profile_address(_root, %{profile_address: profile_address }, _info) do
    case Accounts.create_profile_address(profile_address) do
      {:ok, profile_address} ->
        {:ok, profile_address}

      {:error, error} ->
        {:error, changeset_error_to_graphql("unable to create new profile_address", error)}
    end
  end

  def get_user(_root, %{id: id}, %{context: %{is_admin: true}}) do
    case Accounts.get_user(id) do
      nil ->
        {:error, "user with id #{id} not found"}

      user ->
        {:ok, user}
    end
  end

  def get_user(_root, _args, _info), do: {:error, ResponseUtils.unauthorized_response()}

  def admin_login(_root, %{email: email, password: password}, _info) do
    with {:ok, user} <- Accounts.authenticate_admin(email, password),
         {:ok, token, _claim} <- Accounts.Guardian.encode_and_sign(user) do
      {:ok, token}
    else
      {:error, _} -> {:error, "Failed to login"}
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

  def change_password(_root, %{email: email, old_password: old_password, new_password: new_password}, _info) do
    case Accounts.change_password(email, old_password, new_password) do
      {:ok, _credential} -> {:ok, true}
      {:error, :invalid_credentials} -> {:error, false}
    end
  end

  def me(_root, _args, %{context: %{current_user: current_user}}) do
    {:ok, "Hello #{current_user.profile.first_name} :D"}
  end

  def me(_root, _args, _info), do: {:ok, "I don't know you :("}
end
