defmodule Ruzenkit.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :amount, :decimal, precision: 12, scale: 2, null: false
      add :currency_id, references(:currencies, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:prices, [:currency_id])
  end
end
