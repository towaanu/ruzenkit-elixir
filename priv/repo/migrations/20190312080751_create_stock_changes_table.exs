defmodule Ruzenkit.Repo.Migrations.CreateStockChangesTable do
  use Ecto.Migration

  def change do
    create table(:stock_changes) do
      add :stock_id, references(:stocks, on_delete: :nothing)
      add :operation, :integer, null: false
      add :new_quantity, :integer, null: false
      add :label, :string

      timestamps(type: :utc_datetime)
    end


    create index(:stock_changes, [:stock_id])

  end
end
