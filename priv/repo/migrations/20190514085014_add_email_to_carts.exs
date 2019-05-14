defmodule Ruzenkit.Repo.Migrations.AddEmailToCarts do
  use Ecto.Migration

  def change do
    alter table(:carts) do
      add :email, :string
    end
  end
end
