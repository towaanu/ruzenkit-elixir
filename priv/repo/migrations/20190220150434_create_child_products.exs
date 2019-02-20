defmodule Ruzenkit.Repo.Migrations.CreateChildProducts do
  use Ecto.Migration

  def change do
    create table(:child_products) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :parent_product_id, references(:products, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:child_products, [:product_id])

    create table(:child_products_configurable_item_options) do
      add :child_product_id, references(:parent_products), null: false, primary_key: true
      add :configurable_item_option_id, references(:configurable_item_options), null: false, primary_key: true

    end

    create index("child_products_configurable_item_options", [:child_product_id, :configurable_item_option_id], unique: true)
  end
end
