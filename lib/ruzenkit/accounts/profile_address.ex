defmodule Ruzenkit.Accounts.ProfileAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Accounts.Profile
  alias Ruzenkit.Addresses.Address


  schema "profile_addresses" do
    field :is_default, :boolean, default: false
    belongs_to :profile, Profile
    belongs_to :address, Address

    timestamps()
  end

  @doc false
  def changeset(profile_address, attrs) do
    profile_address
    |> cast(attrs, [:is_default, :profile_id])
    |> cast_assoc(:address, with: &Address.changeset/2)
    |> validate_required([:is_default, :address, :profile_id])
  end
end
