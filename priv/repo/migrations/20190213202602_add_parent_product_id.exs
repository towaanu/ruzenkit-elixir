defmodule Ruzenkit.Repo.Migrations.AddParentProductId do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :parent_product_id, references(:products)
    end
  end
end
