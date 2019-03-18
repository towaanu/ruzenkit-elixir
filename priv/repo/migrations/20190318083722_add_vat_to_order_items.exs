defmodule Ruzenkit.Repo.Migrations.AddVatToOrderItems do
  use Ecto.Migration

  def change do
    alter table(:order_items) do
      add :vat_rate, :float, default: 0.0
      add :vat_label, :string
      add :vat_country_short_iso_code, :string, null: false
      add :vat_country_long_iso_code, :string, null: false
      add :vat_country_english_name, :string, null: false
    end
  end
end
