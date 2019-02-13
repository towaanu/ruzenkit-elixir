defmodule Ruzenkit.ProductsTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Products

  describe "products" do
    alias Ruzenkit.Products.Product

    @valid_attrs %{description: "some description", name: "some name", sku: "some sku"}
    @update_attrs %{description: "some updated description", name: "some updated name", sku: "some updated sku"}
    @invalid_attrs %{description: nil, name: nil, sku: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.sku == "some sku"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.sku == "some updated sku"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "configurable_options" do
    alias Ruzenkit.Products.ConfigurableOption

    @valid_attrs %{label: "some label"}
    @update_attrs %{label: "some updated label"}
    @invalid_attrs %{label: nil}

    def configurable_option_fixture(attrs \\ %{}) do
      {:ok, configurable_option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_configurable_option()

      configurable_option
    end

    test "list_configurable_options/0 returns all configurable_options" do
      configurable_option = configurable_option_fixture()
      assert Products.list_configurable_options() == [configurable_option]
    end

    test "get_configurable_option!/1 returns the configurable_option with given id" do
      configurable_option = configurable_option_fixture()
      assert Products.get_configurable_option!(configurable_option.id) == configurable_option
    end

    test "create_configurable_option/1 with valid data creates a configurable_option" do
      assert {:ok, %ConfigurableOption{} = configurable_option} = Products.create_configurable_option(@valid_attrs)
      assert configurable_option.label == "some label"
    end

    test "create_configurable_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_configurable_option(@invalid_attrs)
    end

    test "update_configurable_option/2 with valid data updates the configurable_option" do
      configurable_option = configurable_option_fixture()
      assert {:ok, %ConfigurableOption{} = configurable_option} = Products.update_configurable_option(configurable_option, @update_attrs)
      assert configurable_option.label == "some updated label"
    end

    test "update_configurable_option/2 with invalid data returns error changeset" do
      configurable_option = configurable_option_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_configurable_option(configurable_option, @invalid_attrs)
      assert configurable_option == Products.get_configurable_option!(configurable_option.id)
    end

    test "delete_configurable_option/1 deletes the configurable_option" do
      configurable_option = configurable_option_fixture()
      assert {:ok, %ConfigurableOption{}} = Products.delete_configurable_option(configurable_option)
      assert_raise Ecto.NoResultsError, fn -> Products.get_configurable_option!(configurable_option.id) end
    end

    test "change_configurable_option/1 returns a configurable_option changeset" do
      configurable_option = configurable_option_fixture()
      assert %Ecto.Changeset{} = Products.change_configurable_option(configurable_option)
    end
  end
end
