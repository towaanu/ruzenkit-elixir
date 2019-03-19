defmodule Ruzenkit.Accounts.ForgotPasswordGuardian do
  use Guardian, otp_app: :ruzenkit

  alias Ruzenkit.Accounts

  def subject_for_token(email, _claims) do
    {:ok, email}
  end

  # add current password_hash
  def build_claims(%{"sub" => email} = claims, _reource, _opts) do
    case Accounts.get_user_by_email(email) do
      %{credential: %{password_hash: password_hash}} ->
        new_claims = Map.put_new(claims, :password_hash, password_hash)
        {:ok, new_claims}

      nil ->
        {:error, :user_not_found}
    end
  end

  def verify_claims(%{"sub" => email, "password_hash" => token_password_hash} = claims, _options) do
    # Check whether password has already been reset using the token
    case Accounts.get_user_by_email(email) do
      %{credential: %{password_hash: password_hash}} ->
        case String.equivalent?(token_password_hash, password_hash) do
          true -> {:ok, claims}
          false -> {:error, :token_already_used}
        end

      nil ->
        {:error, :user_not_found}
    end
  end

  def resource_from_claims(%{"sub" => email}) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
