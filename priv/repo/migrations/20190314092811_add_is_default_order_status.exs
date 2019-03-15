defmodule Ruzenkit.Repo.Migrations.AddIsDefaultOrderStatus do
  use Ecto.Migration

  def change do
    alter table(:order_status) do
      add :is_default, :boolean, default: false, null: false
    end
  end

end
