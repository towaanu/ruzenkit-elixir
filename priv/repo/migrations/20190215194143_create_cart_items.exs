defmodule Ruzenkit.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items) do
      add :quantity, :integer
      add :cart_id, references(:carts, on_delete: :nothing), null: false
      add :product_id, references(:products, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:cart_items, [:cart_id])
    create index(:cart_items, [:product_id])
  end
end
