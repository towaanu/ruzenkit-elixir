defmodule Ruzenkit.Repo.Migrations.CreateVatGroups do
  use Ecto.Migration

  def change do
    create table(:vat_groups) do
      add :rate, :float, default: 0, null: false
      add :label, :string
      add :country_id, references(:countries, on_delete: :delete_all)

      timestamps()
    end

    create index(:vat_groups, [:country_id])

    alter table(:products) do
      add :vat_group_id, references(:vat_groups, on_delete: :nothing)
    end
    create index(:products, [:vat_group_id])

  end
end
