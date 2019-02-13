defmodule Ruzenkit.Repo.Migrations.CreateConfigurableProducts do
  use Ecto.Migration

  def change do
    create table(:configurable_products) do
      add :product_id, references(:products), null: false, primary_key: true
      # timestamps()
    end

  end
end
