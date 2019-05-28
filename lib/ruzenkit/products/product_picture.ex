defmodule Ruzenkit.Products.ProductPicture do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Ruzenkit.Products.Product

  schema "product_pictures" do

    field :picture, Ruzenkit.ArcProductPictures.Type
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product_picture, attrs) do
    product_picture
    |> cast(attrs, [:product_id])
    |> no_warning_cast_attachments(attrs, [:picture])
  end

  @dialyzer {:nowarn_function, no_warning_cast_attachments: 4}

  # Suppressing warning
  defp no_warning_cast_attachments(changeset_or_data, params, allowed, options \\ []) do
    cast_attachments(changeset_or_data, params, allowed, options)
  end

end
