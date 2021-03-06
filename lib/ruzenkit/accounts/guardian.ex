defmodule Ruzenkit.Accounts.Guardian do
  use Guardian, otp_app: :ruzenkit

  alias Ruzenkit.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    # case Accounts.get_user!(id) do
    case Accounts.get_user_with_credential_and_profile!(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
