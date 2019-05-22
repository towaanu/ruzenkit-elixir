defmodule Ruzenkit.Repo.Migrations.AddVatInfoToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :total, :decimal
      add :no_vat_total, :decimal
      add :vat_amount_total, :decimal
    end

    alter table(:order_items) do
      add :total, :decimal
      add :no_vat_price_amount, :decimal
      add :no_vat_total, :decimal
      add :vat_amount_total, :decimal
    end

  end
end
