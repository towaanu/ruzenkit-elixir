defmodule Ruzenkit.Repo.Migrations.ProductsAddPicture do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :picture, :string
    end
  end
end
