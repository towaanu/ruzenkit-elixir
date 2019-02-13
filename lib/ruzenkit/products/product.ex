defmodule Ruzenkit.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset


  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :string

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
