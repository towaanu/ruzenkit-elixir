defmodule Ruzenkit.Products.ConfigurableItemOption do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.ConfigurableOption

  schema "configurable_item_options" do
    field :label, :string
    field :short_label, :string
    field :display_order, :integer

    belongs_to :configurable_option, ConfigurableOption

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(configurable_item_option, attrs) do
    configurable_item_option
    |> cast(attrs, [:label, :short_label, :display_order, :configurable_option_id])
    |> assoc_constraint(:configurable_option)
    |> validate_required([:label, :short_label])
    |> unique_constraint(:display_order, name: :cio_display_order_configurable_option_id_index)
  end
end
