defmodule Ruzenkit.Products.ConfigurableProduct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Products.Product

  schema "configurable_products" do

    belongs_to :product, Product, primary_key: true

    # timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(configurable_product, attrs) do
    configurable_product
    |> cast(attrs, [])
    |> validate_required([])
  end
end
