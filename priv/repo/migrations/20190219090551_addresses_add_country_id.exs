defmodule Ruzenkit.Repo.Migrations.AddressesAddCountryId do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :country_id, references(:countries, on_delete: :nothing), null: false
    end
    create index(:addresses, [:country_id])

  end
end
