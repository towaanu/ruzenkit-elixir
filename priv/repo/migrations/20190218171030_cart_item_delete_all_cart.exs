defmodule Ruzenkit.Repo.Migrations.CartItemDeleteAllCart do
  use Ecto.Migration

  def change do
    drop constraint(:cart_items, "cart_items_cart_id_fkey")

    alter table(:cart_items) do
      modify :cart_id, references(:carts, on_delete: :delete_all)
    end
  end
end
