defmodule Ruzenkit.Products.ParentProduct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ruzenkit.Products.Product
  alias Ruzenkit.Products.ConfigurableOption
  alias Ruzenkit.Products.ChildProduct
  alias Ruzenkit.Repo

  schema "parent_products" do
    belongs_to :product, Product
    many_to_many :configurable_options, ConfigurableOption, join_through: "parent_products_configurable_options"
    has_many :child_products, ChildProduct

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(parent_product, attrs) do
    parent_product
    |> cast(attrs, [])
    |> put_assoc(:configurable_options, get_configurable_options(attrs))
    |> validate_length(:configurable_options, min: 1)
    |> validate_required([])
    |> case do
      %{valid?: false, changes: _changes} = changeset ->
        # If the changeset is invalid we don't want to insert it in parent_product
        # because all required fields are missing, so we ignore it.
        %{changeset | action: :ignore}
      changeset ->
        changeset
    end
  end

  defp get_configurable_options(%{configurable_option_ids: configurable_option_ids}) do
    configurable_option_ids
    |> Enum.filter(& &1) # remove nil
    |> Enum.filter(& &1 != "") # remove nil
    |> Enum.map(fn id ->
      Repo.get(ConfigurableOption, id)
    end)
  end

  defp get_configurable_options(_params), do: []

end
