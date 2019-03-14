defmodule Ruzenkit.Repo.Migrations.CreateParentProducts do
  use Ecto.Migration

  def change do
    create table(:parent_products) do
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)

    end

    create index(:parent_products, [:product_id])


    create table(:parent_products_configurable_options) do
      add :parent_product_id, references(:parent_products), null: false, primary_key: true
      add :configurable_option_id, references(:configurable_options), null: false, primary_key: true

    end

    create index("parent_products_configurable_options", [:parent_product_id, :configurable_option_id], unique: true)

  end
end
