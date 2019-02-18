defmodule Ruzenkit.Repo.Migrations.UsersRemoveFirstNameLastName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :first_name, :string
      remove :last_name, :string
    end
  end
end
