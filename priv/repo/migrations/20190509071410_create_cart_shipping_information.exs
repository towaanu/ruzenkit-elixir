defmodule Ruzenkit.Repo.Migrations.CreateCartShippingInformation do
  use Ecto.Migration

  def change do
    create table(:cart_shipping_information) do

      add :cart_id, references(:carts, on_delete: :delete_all)
      add :shipping_option_id, references(:shipping_options, on_delete: :delete_all)

      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :street, :string, null: false
      add :city, :string, null: false
      add :zip_code, :string, null: false
      add :building, :string
      add :floor, :string
      add :place, :string
      add :extra_info, :string
      add :country_id, references(:countries, on_delete: :nothing)


      timestamps(type: :utc_datetime)
    end

    create index(:cart_shipping_information, [:cart_id])
    create index(:cart_shipping_information, [:shipping_option_id])
    create index(:cart_shipping_information, [:country_id])
  end
end
