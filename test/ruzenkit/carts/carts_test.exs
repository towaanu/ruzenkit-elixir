defmodule Ruzenkit.CartsTest do
  use Ruzenkit.DataCase

  # alias Ruzenkit.Carts

  describe "carts" do
  #   alias Ruzenkit.Carts.Cart

  #   @valid_attrs %{}
  #   @update_attrs %{}
  #   @invalid_attrs %{}

  #   def cart_fixture(attrs \\ %{}) do
  #     {:ok, cart} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Carts.create_cart()

  #     cart
  #   end

  #   test "list_carts/0 returns all carts" do
  #     cart = cart_fixture()
  #     assert Carts.list_carts() == [cart]
  #   end

  #   test "get_cart!/1 returns the cart with given id" do
  #     cart = cart_fixture()
  #     assert Carts.get_cart!(cart.id) == cart
  #   end

  #   test "create_cart/1 with valid data creates a cart" do
  #     assert {:ok, %Cart{} = cart} = Carts.create_cart(@valid_attrs)
  #   end

  #   test "create_cart/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Carts.create_cart(@invalid_attrs)
  #   end

  #   test "update_cart/2 with valid data updates the cart" do
  #     cart = cart_fixture()
  #     assert {:ok, %Cart{} = cart} = Carts.update_cart(cart, @update_attrs)
  #   end

  #   test "update_cart/2 with invalid data returns error changeset" do
  #     cart = cart_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Carts.update_cart(cart, @invalid_attrs)
  #     assert cart == Carts.get_cart!(cart.id)
  #   end

  #   test "delete_cart/1 deletes the cart" do
  #     cart = cart_fixture()
  #     assert {:ok, %Cart{}} = Carts.delete_cart(cart)
  #     assert_raise Ecto.NoResultsError, fn -> Carts.get_cart!(cart.id) end
  #   end

  #   test "change_cart/1 returns a cart changeset" do
  #     cart = cart_fixture()
  #     assert %Ecto.Changeset{} = Carts.change_cart(cart)
  #   end
  # end

  # describe "cart_items" do
  #   alias Ruzenkit.Carts.CartItem

  #   @valid_attrs %{quantity: 42}
  #   @update_attrs %{quantity: 43}
  #   @invalid_attrs %{quantity: nil}

  #   def cart_item_fixture(attrs \\ %{}) do
  #     {:ok, cart_item} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Carts.create_cart_item()

  #     cart_item
  #   end

  #   test "list_cart_items/0 returns all cart_items" do
  #     cart_item = cart_item_fixture()
  #     assert Carts.list_cart_items() == [cart_item]
  #   end

  #   test "get_cart_item!/1 returns the cart_item with given id" do
  #     cart_item = cart_item_fixture()
  #     assert Carts.get_cart_item!(cart_item.id) == cart_item
  #   end

  #   test "create_cart_item/1 with valid data creates a cart_item" do
  #     assert {:ok, %CartItem{} = cart_item} = Carts.create_cart_item(@valid_attrs)
  #     assert cart_item.quantity == 42
  #   end

  #   test "create_cart_item/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Carts.create_cart_item(@invalid_attrs)
  #   end

  #   test "update_cart_item/2 with valid data updates the cart_item" do
  #     cart_item = cart_item_fixture()
  #     assert {:ok, %CartItem{} = cart_item} = Carts.update_cart_item(cart_item, @update_attrs)
  #     assert cart_item.quantity == 43
  #   end

  #   test "update_cart_item/2 with invalid data returns error changeset" do
  #     cart_item = cart_item_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Carts.update_cart_item(cart_item, @invalid_attrs)
  #     assert cart_item == Carts.get_cart_item!(cart_item.id)
  #   end

  #   test "delete_cart_item/1 deletes the cart_item" do
  #     cart_item = cart_item_fixture()
  #     assert {:ok, %CartItem{}} = Carts.delete_cart_item(cart_item)
  #     assert_raise Ecto.NoResultsError, fn -> Carts.get_cart_item!(cart_item.id) end
  #   end

  #   test "change_cart_item/1 returns a cart_item changeset" do
  #     cart_item = cart_item_fixture()
  #     assert %Ecto.Changeset{} = Carts.change_cart_item(cart_item)
  #   end
  end
end
