defmodule Ruzenkit.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :first_name, :string, null: false
      add :last_name, :string,  null: false
      add :street, :string, null: false
      add :city, :string, null: false
      add :zip_code, :string, null: false
      add :building, :string
      add :floor, :string
      add :place, :string
      add :extra_info, :string

      timestamps(type: :utc_datetime)

    end

  end
end
