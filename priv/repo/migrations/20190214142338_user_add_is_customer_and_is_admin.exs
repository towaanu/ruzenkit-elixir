defmodule Ruzenkit.Repo.Migrations.UserAddIsCustomerAndIsAdmin do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, default: false, null: false
      add :is_customer, :boolean, default: true, null: false
    end
  end
end
