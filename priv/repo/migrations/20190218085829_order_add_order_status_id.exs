defmodule Ruzenkit.Repo.Migrations.OrderAddOrderStatusId do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :order_status_id, references(:order_status, on_delete: :nothing)
    end

    create index(:orders, [:order_status_id])

  end
end
