defmodule Ruzenkit.Repo.Migrations.AddShippingNumberToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :shipping_number, :string
    end
  end
end
