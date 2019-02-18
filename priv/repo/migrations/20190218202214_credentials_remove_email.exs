defmodule Ruzenkit.Repo.Migrations.CredentialsRemoveEmail do
  use Ecto.Migration

  def change do
    drop unique_index(:credentials, [:email])
    alter table(:credentials) do
      remove :email, :string
    end
  end
end
