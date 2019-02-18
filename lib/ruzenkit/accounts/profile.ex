defmodule Ruzenkit.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  import Ruzenkit.Utils.String, only: [trim_and_downcase: 1]

  alias Ruzenkit.Accounts.User

  schema "profiles" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:email])
    |> update_change(:first_name, &trim_and_downcase/1)
    |> update_change(:last_name, &trim_and_downcase/1)
    |> update_change(:email, &trim_and_downcase/1)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

end
