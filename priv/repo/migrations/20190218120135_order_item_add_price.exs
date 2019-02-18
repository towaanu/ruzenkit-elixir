defmodule Ruzenkit.Repo.Migrations.OrderItemAddPrice do
  use Ecto.Migration

  def change do
    alter table(:order_items) do
      add :price_amount, :decimal, precision: 12, scale: 2, null: false
      add :price_currency_code, :string, null: false
      add :price_currency_sign, :string, null: false
    end

  end
end
