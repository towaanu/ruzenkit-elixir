defmodule Ruzenkit.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.ConfigurableProduct
  alias Ruzenkit.Products.ProductPrice
  alias Ruzenkit.Products.ChildProduct
  alias Ruzenkit.Products.ParentProduct
  alias Ruzenkit.Stocks.Stock
  alias Ruzenkit.Vat.VatGroup

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :string

    belongs_to :price, ProductPrice, foreign_key: :product_price_id
    belongs_to :vat_group, VatGroup

    has_one :configurable_Product, ConfigurableProduct
    has_one :stock, Stock
    has_one :child_product, ChildProduct
    has_one :parent_product, ParentProduct


    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description, :vat_group_id])
    |> validate_required([:sku, :name, :description])
    |> unique_constraint(:sku)
    |> foreign_key_constraint(:parent_product_id)
    |> foreign_key_constraint(:vat_group_id)
  end
end
