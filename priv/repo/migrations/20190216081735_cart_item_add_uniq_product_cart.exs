defmodule Ruzenkit.Repo.Migrations.CartItemAddUniqProductCart do
  use Ecto.Migration

  def change do

    create unique_index(:cart_items, [:cart_id, :product_id])
  end
end
