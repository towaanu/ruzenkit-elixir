defmodule Ruzenkit.Repo.Migrations.CreateProfileAddresses do
  use Ecto.Migration

  def change do
    create table(:profile_addresses) do
      add :is_default, :boolean, default: false, null: false
      add :profile_id, references(:profiles, on_delete: :delete_all), null: false
      add :address_id, references(:addresses, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:profile_addresses, [:profile_id])
    create index(:profile_addresses, [:address_id], unique: true)
  end
end
