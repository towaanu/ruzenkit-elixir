defmodule Ruzenkit.Repo.Migrations.ProductsRemoveParentProductId do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :parent_product_id
    end
  end
end
