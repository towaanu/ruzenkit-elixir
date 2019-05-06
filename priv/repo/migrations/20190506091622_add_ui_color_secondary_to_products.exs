defmodule Ruzenkit.Repo.Migrations.AddUiColorSecondaryToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :ui_color_secondary, :string, size: 7
    end
  end
end
