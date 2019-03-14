defmodule Ruzenkit.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :sku, :string
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)

    end

    create unique_index(:products, [:sku])
  end
end
