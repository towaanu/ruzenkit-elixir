defmodule Ruzenkit.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.ConfigurableOption
  alias Ruzenkit.Products.ConfigurableProduct
  alias Ruzenkit.Products.ProductPrice
  alias Ruzenkit.Stocks.Stock
  alias Ruzenkit.Vat.VatGroup

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :string

    belongs_to :price, ProductPrice, foreign_key: :product_price_id
    belongs_to :parent_product, Ruzenkit.Products.Product
    belongs_to :vat_group, VatGroup

    many_to_many :configurable_options, ConfigurableOption, join_through: "products_configurable_options"
    has_many :child_products, Ruzenkit.Products.Product
    has_one :configurable_Product, ConfigurableProduct
    has_one :stock, Stock

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description, :parent_product_id, :vat_group_id])
    |> Ecto.Changeset.assoc_constraint(:parent_product)
    |> validate_required([:sku, :name, :description])
    |> unique_constraint(:sku)
    |> foreign_key_constraint(:parent_product_id)
    |> foreign_key_constraint(:vat_group_id)
  end
end
