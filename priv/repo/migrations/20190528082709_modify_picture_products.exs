defmodule Ruzenkit.Repo.Migrations.ModifyPictureProducts do
  use Ecto.Migration

  def change do
    # alter table(:products) do
    #   remove :picture
    # end

    create table(:product_pictures) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :picture, :string

      timestamps(type: :utc_datetime)
    end

    create index(:product_pictures, [:product_id])

  end
end
