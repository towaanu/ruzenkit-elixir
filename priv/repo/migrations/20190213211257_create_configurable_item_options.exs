defmodule Ruzenkit.Repo.Migrations.CreateConfigurableItemOptions do
  use Ecto.Migration

  def change do
    create table(:configurable_item_options) do
      add :label, :string
      add :short_label, :string
      add :configurable_option_id, references(:configurable_options), null: false

      timestamps(type: :utc_datetime)

    end

  end
end
