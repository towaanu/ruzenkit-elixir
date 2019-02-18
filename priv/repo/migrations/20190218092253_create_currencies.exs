defmodule Ruzenkit.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :name, :string, null: false
      add :sign, :string, size: 10, null: false
      add :code, :string, size: 10, null: false

      timestamps()
    end

    create unique_index(:currencies, [:code])
  end
end
