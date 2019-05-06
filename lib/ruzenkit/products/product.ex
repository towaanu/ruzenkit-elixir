defmodule Ruzenkit.Products.Product do
  use Ecto.Schema
  use Arc.Ecto.Schema
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
    field :ui_color, :string
    field :ui_color_secondary, :string
    field :picture, Ruzenkit.ProductPicture.Type

    belongs_to :price, ProductPrice, foreign_key: :product_price_id, on_replace: :update
    belongs_to :vat_group, VatGroup

    has_one :configurable_Product, ConfigurableProduct
    has_one :stock, Stock
    has_one :child_product, ChildProduct
    has_one :parent_product, ParentProduct


    timestamps(type: :utc_datetime)

  end


  @doc false
  def changeset(product, attrs) do

    product
    |> cast(attrs, [:sku, :name, :description, :ui_color, :ui_color_secondary, :vat_group_id])
    |> no_warning_cast_attachments(attrs, [:picture])
    # |> cast_attachments(attrs, [:picture])
    |> cast_assoc(:price)
    |> validate_required([:sku, :name, :description])
    |> validate_length(:ui_color, max: 7)
    |> validate_length(:ui_color_secondary, max: 7)
    |> unique_constraint(:sku)
    |> foreign_key_constraint(:parent_product_id)
    |> foreign_key_constraint(:vat_group_id)
  end

  @dialyzer {:nowarn_function, no_warning_cast_attachments: 4}

  # Suppressing warning
  defp no_warning_cast_attachments(changeset_or_data, params, allowed, options \\ []) do
    cast_attachments(changeset_or_data, params, allowed, options)
  end

end
