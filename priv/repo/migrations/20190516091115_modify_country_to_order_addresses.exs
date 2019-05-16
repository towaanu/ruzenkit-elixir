defmodule Ruzenkit.Repo.Migrations.ModifyCountryToOrderAddresses do
  use Ecto.Migration

  def change do
    alter table(:order_addresses) do
      remove :country
      add :country_id, references(:countries, on_delete: :nothing)
    end
    create index(:order_addresses, [:country_id])
  end
end
