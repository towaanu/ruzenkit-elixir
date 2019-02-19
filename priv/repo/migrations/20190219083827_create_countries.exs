defmodule Ruzenkit.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :english_name, :string, null: false
      add :local_name, :string, null: false
      add :short_iso_code, :string, null: false
      add :long_iso_code, :string, null: false

      timestamps()
    end

    create unique_index(:countries, [:short_iso_code])
    create unique_index(:countries, [:long_iso_code])
  end
end
