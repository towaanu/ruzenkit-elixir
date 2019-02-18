defmodule Ruzenkit.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Accounts.Credential
  alias Ruzenkit.Accounts.Profile

  schema "users" do
    # field :first_name, :string
    # field :last_name, :string
    field :is_admin, :boolean, default: false
    field :is_customer, :boolean, default: true
    has_one :credential, Credential
    has_one :profile, Profile

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
