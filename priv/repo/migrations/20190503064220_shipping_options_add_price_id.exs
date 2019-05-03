defmodule Ruzenkit.Repo.Migrations.ShippingOptionsAddPriceId do
  use Ecto.Migration

  def change do
    alter table(:shipping_options) do
      add :price_id, references(:prices, on_delete: :delete_all)
    end
    create index(:prices, [:id])
  end
end
