defmodule Ruzenkit.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.ConfigurableOption

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :string

    many_to_many :configurable_options, ConfigurableOption, join_through: "products_configurable_options"

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description])
    |> validate_required([:sku, :name, :description])
    |> unique_constraint(:sku)
  end
end
