defmodule Ruzenkit.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Accounts.Credential

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :is_admin, :boolean, default: false
    field :is_customer, :boolean, default: true
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end