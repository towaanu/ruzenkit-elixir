defmodule Ruzenkit.Repo.Migrations.CreateOrderStatus do
  use Ecto.Migration

  def change do
    create table(:order_status) do
      add :label, :string

      timestamps(type: :utc_datetime)

    end

    create index(:order_status, ["lower(label)"], name: :order_status_label_index, unique: true)
  end
end
