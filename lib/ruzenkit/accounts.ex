defmodule Ruzenkit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ruzenkit.Repo

  alias Ruzenkit.Accounts.User
  alias Ruzenkit.Accounts.Credential
  alias Ruzenkit.Accounts.Profile
  alias Ruzenkit.Accounts
  alias Ruzenkit.Email
  alias Ruzenkit.Accounts.ForgotPasswordGuardian

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def get_user_with_credential!(id), do: User |> Repo.get!(id) |> Repo.preload(:credential)

  def get_user_with_credential_and_profile!(id) do
    User |> Repo.get!(id) |> Repo.preload([:credential, :profile])
  end

  def get_user_by_email(email) do
    user_query =
      from u in User,
        inner_join: p in assoc(u, :profile),
        where: p.email == ^email,
        preload: [:credential, :profile]

    user_query
    |> Repo.one()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Ecto.Changeset.cast_assoc(:profile, with: &Profile.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns the list of credentials.

  ## Examples

      iex> list_credentials()
      [%Credential{}, ...]

  """
  def list_credentials do
    Repo.all(Credential)
  end

  @doc """
  Gets a single credential.

  Raises `Ecto.NoResultsError` if the Credential does not exist.

  ## Examples

      iex> get_credential!(123)
      %Credential{}

      iex> get_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credential!(id), do: Repo.get!(Credential, id)

  @doc """
  Creates a credential.

  ## Examples

      iex> create_credential(%{field: value})
      {:ok, %Credential{}}

      iex> create_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credential.

  ## Examples

      iex> update_credential(credential, %{field: new_value})
      {:ok, %Credential{}}

      iex> update_credential(credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Credential.

  ## Examples

      iex> delete_credential(credential)
      {:ok, %Credential{}}

      iex> delete_credential(credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credential changes.

  ## Examples

      iex> change_credential(credential)
      %Ecto.Changeset{source: %Credential{}}

  """
  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end

  def change_password(email, old_password, new_password) do
    case authenticate_user(email, old_password) do
      {:ok, user} ->
        user.credential
        |> update_credential(%{password: new_password})

      {:error, :invalid_credentials} ->
        {:error, :invalid_credentials}
    end
  end

  def send_forgot_password_email(email, token) do
    Email.forgot_password_email(email: email, token: token)
    |> Email.send_mail()
  end

  def forgot_password(email) do
    case ForgotPasswordGuardian.encode_and_sign(email) do
      {:ok, token, _claims} -> send_forgot_password_email(email, token)
      {:error, error} -> {:error, error}
    end
  end

  def reset_password(token, new_password) do
    case ForgotPasswordGuardian.resource_from_token(token) do
      {:ok, %{credential: credential}, _claims} ->
        update_credential(credential, %{password: new_password})

      {:error, error} ->
        {:error, error}
    end
  end

  def authenticate_user(email, password) do
    query =
      from u in User,
        inner_join: p in assoc(u, :profile),
        where: p.email == ^email,
        preload: [:credential, :profile]

    case Repo.one(query) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.verify_pass(password, user.credential.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def authenticate_admin(email, password) do
    query =
      from u in User,
        inner_join: p in assoc(u, :profile),
        where: p.email == ^email and u.is_admin == true,
        preload: [:credential, :profile]

    case Repo.one(query) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.verify_pass(password, user.credential.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def revoke_auth_token(token) do
    Accounts.Guardian.revoke(token)
  end

  alias Ruzenkit.Accounts.Profile

  @doc """
  Returns the list of profile.

  ## Examples

      iex> list_profile()
      [%Profile{}, ...]

  """
  def list_profile do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end

  alias Ruzenkit.Accounts.ProfileAddress

  @doc """
  Returns the list of profile_addresses.

  ## Examples

      iex> list_profile_addresses()
      [%ProfileAddress{}, ...]

  """
  def list_profile_addresses do
    Repo.all(ProfileAddress)
  end

  @doc """
  Gets a single profile_address.

  Raises `Ecto.NoResultsError` if the Profile address does not exist.

  ## Examples

      iex> get_profile_address!(123)
      %ProfileAddress{}

      iex> get_profile_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile_address!(id), do: Repo.get!(ProfileAddress, id)

  @doc """
  Creates a profile_address.

  ## Examples

      iex> create_profile_address(%{field: value})
      {:ok, %ProfileAddress{}}

      iex> create_profile_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile_address(attrs \\ %{}) do
    %ProfileAddress{}
    |> ProfileAddress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile_address.

  ## Examples

      iex> update_profile_address(profile_address, %{field: new_value})
      {:ok, %ProfileAddress{}}

      iex> update_profile_address(profile_address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile_address(%ProfileAddress{} = profile_address, attrs) do
    profile_address
    |> ProfileAddress.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProfileAddress.

  ## Examples

      iex> delete_profile_address(profile_address)
      {:ok, %ProfileAddress{}}

      iex> delete_profile_address(profile_address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile_address(%ProfileAddress{} = profile_address) do
    Repo.delete(profile_address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile_address changes.

  ## Examples

      iex> change_profile_address(profile_address)
      %Ecto.Changeset{source: %ProfileAddress{}}

  """
  def change_profile_address(%ProfileAddress{} = profile_address) do
    ProfileAddress.changeset(profile_address, %{})
  end
end
