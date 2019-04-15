defmodule Ruzenkit.Repo.Migrations.AddUiColorToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :ui_color, :string, size: 7
    end
  end
end
