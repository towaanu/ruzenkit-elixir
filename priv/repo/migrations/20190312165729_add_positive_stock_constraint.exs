defmodule Ruzenkit.Repo.Migrations.AddPositiveStockConstraint do
  use Ecto.Migration

  def change do
    create constraint("stocks", :quantity_must_be_positive, check: "quantity >= 0")
    create constraint("stock_changes", :new_quantity_must_be_positive, check: "new_quantity >= 0")
  end
end
