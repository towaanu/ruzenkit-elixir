defmodule Ruzenkit.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table(:stocks) do
      add :quantity, :integer, default: 0, null: false
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)

    end

    create index(:stocks, [:product_id])
  end
end
