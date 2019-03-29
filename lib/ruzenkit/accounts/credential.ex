defmodule Ruzenkit.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Accounts.User

  schema "credentials" do
    field :password_hash, :string
    field :password, :string, virtual: true
    belongs_to :user, User

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 5, max: 20)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset

end
