defmodule Ruzenkit.Repo.Migrations.CreateOrderAddressesTable do
  use Ecto.Migration

  def change do
    create table(:order_addresses) do
      add :first_name, :string, null: false
      add :last_name, :string,  null: false
      add :street, :string, null: false
      add :city, :string, null: false
      add :zip_code, :string, null: false
      add :building, :string
      add :floor, :string
      add :place, :string
      add :extra_info, :string
      add :country, :string

      add :order_id, references(:orders, on_delete: :delete_all)

      timestamps(type: :utc_datetime)

    end

    # alter table(:orders) do
    #   add :order_address_id, references(:order_addresses, on_delete: :delete_all)
    # end

    create index(:order_addresses, [:order_id])

  end
end
