defmodule Ruzenkit.Repo.Migrations.AddProductsConfigurableOptions do
  use Ecto.Migration

  def change do
    create table(:products_configurable_options) do
      add :product_id, references(:products), null: false, primary_key: true
      add :configurable_option_id, references(:configurable_options), null: false, primary_key: true

    end

    create index("products_configurable_options", [:product_id, :configurable_option_id], unique: true)

  end
end
