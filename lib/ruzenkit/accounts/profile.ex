defmodule Ruzenkit.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  import Ruzenkit.Utils.StringUtils, only: [trim_and_downcase: 1]

  alias Ruzenkit.Accounts.User
  alias Ruzenkit.Accounts.ProfileAddress

  schema "profiles" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    belongs_to :user, User
    has_many :profile_addresses, ProfileAddress

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:first_name, :last_name, :email])
    |> cast_assoc(:profile_addresses, with: &ProfileAddress.changeset/2)
    |> validate_required([:email])
    |> update_change(:first_name, &trim_and_downcase/1)
    |> update_change(:last_name, &trim_and_downcase/1)
    |> update_change(:email, &trim_and_downcase/1)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

end
