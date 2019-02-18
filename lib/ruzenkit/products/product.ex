defmodule Ruzenkit.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.ConfigurableOption
  alias Ruzenkit.Products.ConfigurableProduct
  alias Ruzenkit.Products.ProductPrice

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :string

    belongs_to :price, ProductPrice, foreign_key: :product_price_id
    belongs_to :parent_product, Ruzenkit.Products.Product

    many_to_many :configurable_options, ConfigurableOption, join_through: "products_configurable_options"
    has_many :child_products, Ruzenkit.Products.Product
    has_one :configurable_Product, ConfigurableProduct

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description, :parent_product_id])
    |> Ecto.Changeset.assoc_constraint(:parent_product)
    |> validate_required([:sku, :name, :description])
    |> unique_constraint(:sku)
  end
end
