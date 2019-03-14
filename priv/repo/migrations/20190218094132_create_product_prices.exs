defmodule Ruzenkit.Repo.Migrations.CreateProductPrices do
  use Ecto.Migration

  def change do
    create table(:product_prices) do
      add :amount, :decimal, precision: 12, scale: 2, null: false
      add :currency_id, references(:currencies, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)

    end

    create index(:product_prices, [:currency_id])

    alter table(:products) do
      add :product_price_id, references(:product_prices, on_delete: :nothing)
    end

    create index(:products, [:product_price_id])
    create constraint(:product_prices, :amount_must_be_positive, check: "amount >= 0")
  end
end
