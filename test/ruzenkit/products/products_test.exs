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

  describe "configurable_products" do
    alias Ruzenkit.Products.ConfigurableProduct

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def configurable_product_fixture(attrs \\ %{}) do
      {:ok, configurable_product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_configurable_product()

      configurable_product
    end

    test "list_configurable_products/0 returns all configurable_products" do
      configurable_product = configurable_product_fixture()
      assert Products.list_configurable_products() == [configurable_product]
    end

    test "get_configurable_product!/1 returns the configurable_product with given id" do
      configurable_product = configurable_product_fixture()
      assert Products.get_configurable_product!(configurable_product.id) == configurable_product
    end

    test "create_configurable_product/1 with valid data creates a configurable_product" do
      assert {:ok, %ConfigurableProduct{} = configurable_product} = Products.create_configurable_product(@valid_attrs)
    end

    test "create_configurable_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_configurable_product(@invalid_attrs)
    end

    test "update_configurable_product/2 with valid data updates the configurable_product" do
      configurable_product = configurable_product_fixture()
      assert {:ok, %ConfigurableProduct{} = configurable_product} = Products.update_configurable_product(configurable_product, @update_attrs)
    end

    test "update_configurable_product/2 with invalid data returns error changeset" do
      configurable_product = configurable_product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_configurable_product(configurable_product, @invalid_attrs)
      assert configurable_product == Products.get_configurable_product!(configurable_product.id)
    end

    test "delete_configurable_product/1 deletes the configurable_product" do
      configurable_product = configurable_product_fixture()
      assert {:ok, %ConfigurableProduct{}} = Products.delete_configurable_product(configurable_product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_configurable_product!(configurable_product.id) end
    end

    test "change_configurable_product/1 returns a configurable_product changeset" do
      configurable_product = configurable_product_fixture()
      assert %Ecto.Changeset{} = Products.change_configurable_product(configurable_product)
    end
  end

  describe "configurable_item_options" do
    alias Ruzenkit.Products.ConfigurableItemOption

    @valid_attrs %{label: "some label", short_label: "some short_label"}
    @update_attrs %{label: "some updated label", short_label: "some updated short_label"}
    @invalid_attrs %{label: nil, short_label: nil}

    def configurable_item_option_fixture(attrs \\ %{}) do
      {:ok, configurable_item_option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_configurable_item_option()

      configurable_item_option
    end

    test "list_configurable_item_options/0 returns all configurable_item_options" do
      configurable_item_option = configurable_item_option_fixture()
      assert Products.list_configurable_item_options() == [configurable_item_option]
    end

    test "get_configurable_item_option!/1 returns the configurable_item_option with given id" do
      configurable_item_option = configurable_item_option_fixture()
      assert Products.get_configurable_item_option!(configurable_item_option.id) == configurable_item_option
    end

    test "create_configurable_item_option/1 with valid data creates a configurable_item_option" do
      assert {:ok, %ConfigurableItemOption{} = configurable_item_option} = Products.create_configurable_item_option(@valid_attrs)
      assert configurable_item_option.label == "some label"
      assert configurable_item_option.short_label == "some short_label"
    end

    test "create_configurable_item_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_configurable_item_option(@invalid_attrs)
    end

    test "update_configurable_item_option/2 with valid data updates the configurable_item_option" do
      configurable_item_option = configurable_item_option_fixture()
      assert {:ok, %ConfigurableItemOption{} = configurable_item_option} = Products.update_configurable_item_option(configurable_item_option, @update_attrs)
      assert configurable_item_option.label == "some updated label"
      assert configurable_item_option.short_label == "some updated short_label"
    end

    test "update_configurable_item_option/2 with invalid data returns error changeset" do
      configurable_item_option = configurable_item_option_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_configurable_item_option(configurable_item_option, @invalid_attrs)
      assert configurable_item_option == Products.get_configurable_item_option!(configurable_item_option.id)
    end

    test "delete_configurable_item_option/1 deletes the configurable_item_option" do
      configurable_item_option = configurable_item_option_fixture()
      assert {:ok, %ConfigurableItemOption{}} = Products.delete_configurable_item_option(configurable_item_option)
      assert_raise Ecto.NoResultsError, fn -> Products.get_configurable_item_option!(configurable_item_option.id) end
    end

    test "change_configurable_item_option/1 returns a configurable_item_option changeset" do
      configurable_item_option = configurable_item_option_fixture()
      assert %Ecto.Changeset{} = Products.change_configurable_item_option(configurable_item_option)
    end
  end

  describe "product_prices" do
    alias Ruzenkit.Products.ProductPrice

    @valid_attrs %{amount: "120.5"}
    @update_attrs %{amount: "456.7"}
    @invalid_attrs %{amount: nil}

    def product_price_fixture(attrs \\ %{}) do
      {:ok, product_price} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product_price()

      product_price
    end

    test "list_product_prices/0 returns all product_prices" do
      product_price = product_price_fixture()
      assert Products.list_product_prices() == [product_price]
    end

    test "get_product_price!/1 returns the product_price with given id" do
      product_price = product_price_fixture()
      assert Products.get_product_price!(product_price.id) == product_price
    end

    test "create_product_price/1 with valid data creates a product_price" do
      assert {:ok, %ProductPrice{} = product_price} = Products.create_product_price(@valid_attrs)
      assert product_price.amount == Decimal.new("120.5")
    end

    test "create_product_price/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_price(@invalid_attrs)
    end

    test "update_product_price/2 with valid data updates the product_price" do
      product_price = product_price_fixture()
      assert {:ok, %ProductPrice{} = product_price} = Products.update_product_price(product_price, @update_attrs)
      assert product_price.amount == Decimal.new("456.7")
    end

    test "update_product_price/2 with invalid data returns error changeset" do
      product_price = product_price_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product_price(product_price, @invalid_attrs)
      assert product_price == Products.get_product_price!(product_price.id)
    end

    test "delete_product_price/1 deletes the product_price" do
      product_price = product_price_fixture()
      assert {:ok, %ProductPrice{}} = Products.delete_product_price(product_price)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_price!(product_price.id) end
    end

    test "change_product_price/1 returns a product_price changeset" do
      product_price = product_price_fixture()
      assert %Ecto.Changeset{} = Products.change_product_price(product_price)
    end
  end

  describe "parent_products" do
    alias Ruzenkit.Products.ParentProduct

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def parent_product_fixture(attrs \\ %{}) do
      {:ok, parent_product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_parent_product()

      parent_product
    end

    test "list_parent_products/0 returns all parent_products" do
      parent_product = parent_product_fixture()
      assert Products.list_parent_products() == [parent_product]
    end

    test "get_parent_product!/1 returns the parent_product with given id" do
      parent_product = parent_product_fixture()
      assert Products.get_parent_product!(parent_product.id) == parent_product
    end

    test "create_parent_product/1 with valid data creates a parent_product" do
      assert {:ok, %ParentProduct{} = parent_product} = Products.create_parent_product(@valid_attrs)
    end

    test "create_parent_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_parent_product(@invalid_attrs)
    end

    test "update_parent_product/2 with valid data updates the parent_product" do
      parent_product = parent_product_fixture()
      assert {:ok, %ParentProduct{} = parent_product} = Products.update_parent_product(parent_product, @update_attrs)
    end

    test "update_parent_product/2 with invalid data returns error changeset" do
      parent_product = parent_product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_parent_product(parent_product, @invalid_attrs)
      assert parent_product == Products.get_parent_product!(parent_product.id)
    end

    test "delete_parent_product/1 deletes the parent_product" do
      parent_product = parent_product_fixture()
      assert {:ok, %ParentProduct{}} = Products.delete_parent_product(parent_product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_parent_product!(parent_product.id) end
    end

    test "change_parent_product/1 returns a parent_product changeset" do
      parent_product = parent_product_fixture()
      assert %Ecto.Changeset{} = Products.change_parent_product(parent_product)
    end
  end

  describe "child_products" do
    alias Ruzenkit.Products.ChildProduct

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def child_product_fixture(attrs \\ %{}) do
      {:ok, child_product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_child_product()

      child_product
    end

    test "list_child_products/0 returns all child_products" do
      child_product = child_product_fixture()
      assert Products.list_child_products() == [child_product]
    end

    test "get_child_product!/1 returns the child_product with given id" do
      child_product = child_product_fixture()
      assert Products.get_child_product!(child_product.id) == child_product
    end

    test "create_child_product/1 with valid data creates a child_product" do
      assert {:ok, %ChildProduct{} = child_product} = Products.create_child_product(@valid_attrs)
    end

    test "create_child_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_child_product(@invalid_attrs)
    end

    test "update_child_product/2 with valid data updates the child_product" do
      child_product = child_product_fixture()
      assert {:ok, %ChildProduct{} = child_product} = Products.update_child_product(child_product, @update_attrs)
    end

    test "update_child_product/2 with invalid data returns error changeset" do
      child_product = child_product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_child_product(child_product, @invalid_attrs)
      assert child_product == Products.get_child_product!(child_product.id)
    end

    test "delete_child_product/1 deletes the child_product" do
      child_product = child_product_fixture()
      assert {:ok, %ChildProduct{}} = Products.delete_child_product(child_product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_child_product!(child_product.id) end
    end

    test "change_child_product/1 returns a child_product changeset" do
      child_product = child_product_fixture()
      assert %Ecto.Changeset{} = Products.change_child_product(child_product)
    end
  end
end
