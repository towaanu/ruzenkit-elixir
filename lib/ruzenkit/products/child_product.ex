defmodule Ruzenkit.Products.ChildProduct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Products.Product
  alias Ruzenkit.Products.ConfigurableItemOption
  alias Ruzenkit.Products.ParentProduct
  alias Ruzenkit.Repo

  schema "child_products" do
    belongs_to :product, Product
    belongs_to :parent_product, ParentProduct

    many_to_many :configurable_item_options, ConfigurableItemOption,
      join_through: "child_products_configurable_item_options"

    timestamps()
  end

  @doc false
  def changeset(child_product, attrs) do
    child_product
    |> cast(attrs, [:parent_product_id])
    # |> cast_assoc(:product)
    |> put_assoc(:configurable_item_options, get_configurable_item_options(attrs))
    |> validate_required([])
    |> foreign_key_constraint(:parent_product_id)
  end

  defp get_configurable_item_options(%{configurable_item_option_ids: configurable_item_option_ids}) do
    configurable_item_option_ids
    |> Enum.filter(& &1) # remove nil
    |> Enum.map(fn id ->
      Repo.get(ConfigurableItemOption, id)
    end)
  end

  defp get_configurable_item_options(_params), do: []

end
