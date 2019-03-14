defmodule Ruzenkit.Repo.Migrations.CreateShippingOptions do
  use Ecto.Migration

  def change do
    create table(:shipping_options) do
      add :name, :string, null: false
      add :description, :string
      add :shipping_hour_time, :float
      add :shipping_carrier_id, references(:shipping_carriers, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)

    end

    create index(:shipping_options, [:shipping_carrier_id])

    create table(:shipping_options_countries) do
      add :shipping_option_id, references(:shipping_options), null: false, primary_key: true
      add :country_id, references(:countries), null: false, primary_key: true

    end

    create index(:shipping_options_countries, [:shipping_option_id, :country_id], unique: true)

  end
end
