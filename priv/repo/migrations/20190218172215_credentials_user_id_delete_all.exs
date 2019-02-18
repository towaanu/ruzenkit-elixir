defmodule Ruzenkit.Repo.Migrations.CartItemDeleteAllCart do
  use Ecto.Migration

  def change do
    drop constraint(:credentials, "credentials_user_id_fkey")

    alter table(:credentials) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
