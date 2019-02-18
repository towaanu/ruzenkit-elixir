defmodule Ruzenkit.OrdersTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Orders

  describe "orders" do
    alias Ruzenkit.Orders.Order

    @valid_attrs %{total: "120.5"}
    @update_attrs %{total: "456.7"}
    @invalid_attrs %{total: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Orders.create_order(@valid_attrs)
      assert order.total == Decimal.new("120.5")
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = Orders.update_order(order, @update_attrs)
      assert order.total == Decimal.new("456.7")
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end

  describe "order_items" do
    alias Ruzenkit.Orders.OrderItem

    @valid_attrs %{quantity: 42}
    @update_attrs %{quantity: 43}
    @invalid_attrs %{quantity: nil}

    def order_item_fixture(attrs \\ %{}) do
      {:ok, order_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_order_item()

      order_item
    end

    test "list_order_items/0 returns all order_items" do
      order_item = order_item_fixture()
      assert Orders.list_order_items() == [order_item]
    end

    test "get_order_item!/1 returns the order_item with given id" do
      order_item = order_item_fixture()
      assert Orders.get_order_item!(order_item.id) == order_item
    end

    test "create_order_item/1 with valid data creates a order_item" do
      assert {:ok, %OrderItem{} = order_item} = Orders.create_order_item(@valid_attrs)
      assert order_item.quantity == 42
    end

    test "create_order_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order_item(@invalid_attrs)
    end

    test "update_order_item/2 with valid data updates the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{} = order_item} = Orders.update_order_item(order_item, @update_attrs)
      assert order_item.quantity == 43
    end

    test "update_order_item/2 with invalid data returns error changeset" do
      order_item = order_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order_item(order_item, @invalid_attrs)
      assert order_item == Orders.get_order_item!(order_item.id)
    end

    test "delete_order_item/1 deletes the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{}} = Orders.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_item!(order_item.id) end
    end

    test "change_order_item/1 returns a order_item changeset" do
      order_item = order_item_fixture()
      assert %Ecto.Changeset{} = Orders.change_order_item(order_item)
    end
  end

  describe "order_status" do
    alias Ruzenkit.Orders.OrderStatus

    @valid_attrs %{label: "some label"}
    @update_attrs %{label: "some updated label"}
    @invalid_attrs %{label: nil}

    def order_status_fixture(attrs \\ %{}) do
      {:ok, order_status} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_order_status()

      order_status
    end

    test "list_order_status/0 returns all order_status" do
      order_status = order_status_fixture()
      assert Orders.list_order_status() == [order_status]
    end

    test "get_order_status!/1 returns the order_status with given id" do
      order_status = order_status_fixture()
      assert Orders.get_order_status!(order_status.id) == order_status
    end

    test "create_order_status/1 with valid data creates a order_status" do
      assert {:ok, %OrderStatus{} = order_status} = Orders.create_order_status(@valid_attrs)
      assert order_status.label == "some label"
    end

    test "create_order_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order_status(@invalid_attrs)
    end

    test "update_order_status/2 with valid data updates the order_status" do
      order_status = order_status_fixture()
      assert {:ok, %OrderStatus{} = order_status} = Orders.update_order_status(order_status, @update_attrs)
      assert order_status.label == "some updated label"
    end

    test "update_order_status/2 with invalid data returns error changeset" do
      order_status = order_status_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order_status(order_status, @invalid_attrs)
      assert order_status == Orders.get_order_status!(order_status.id)
    end

    test "delete_order_status/1 deletes the order_status" do
      order_status = order_status_fixture()
      assert {:ok, %OrderStatus{}} = Orders.delete_order_status(order_status)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_status!(order_status.id) end
    end

    test "change_order_status/1 returns a order_status changeset" do
      order_status = order_status_fixture()
      assert %Ecto.Changeset{} = Orders.change_order_status(order_status)
    end
  end
end
