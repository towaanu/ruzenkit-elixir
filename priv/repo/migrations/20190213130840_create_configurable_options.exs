defmodule Ruzenkit.Repo.Migrations.CreateConfigurableOptions do
  use Ecto.Migration

  def change do
    create table(:configurable_options) do
      add :label, :string

      timestamps()
    end

  end
end
