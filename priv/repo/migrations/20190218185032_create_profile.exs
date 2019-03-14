defmodule Ruzenkit.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)

    end

    create unique_index(:profiles, [:email])
    create index(:profiles, [:user_id])
  end
end
