defmodule Ruzenkit.Products.ConfigurableOption do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.Product
  alias Ruzenkit.Products.ConfigurableItemOption

  schema "configurable_options" do
    field :label, :string

    many_to_many :products, Product, join_through: "products_configurable_options"
    has_many :configurable_item_options, ConfigurableItemOption

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(configurable_option, attrs) do
    configurable_option
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
