defmodule Ruzenkit.Repo.Migrations.CreateShippingCarriers do
  use Ecto.Migration

  def change do
    create table(:shipping_carriers) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)

    end

  end
end
