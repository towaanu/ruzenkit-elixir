defmodule Ruzenkit.Repo.Migrations.AddDisplayOrderToConfigurableItemOptions do
  use Ecto.Migration

  def change do
    alter table(:configurable_item_options) do
      add :display_order, :integer
    end

    # create unique_index(:configurable_item_options, [:display_order, :configurable_option_id])
    create unique_index(:configurable_item_options, [:display_order, :configurable_option_id], name: :cio_display_order_configurable_option_id_index)

  end
end
