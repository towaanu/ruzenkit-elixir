defmodule Ruzenkit.ShippingsTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Shippings

  describe "shipping_carriers" do
    alias Ruzenkit.Shippings.ShippingCarrier

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def shipping_carrier_fixture(attrs \\ %{}) do
      {:ok, shipping_carrier} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shippings.create_shipping_carrier()

      shipping_carrier
    end

    test "list_shipping_carriers/0 returns all shipping_carriers" do
      shipping_carrier = shipping_carrier_fixture()
      assert Shippings.list_shipping_carriers() == [shipping_carrier]
    end

    test "get_shipping_carrier!/1 returns the shipping_carrier with given id" do
      shipping_carrier = shipping_carrier_fixture()
      assert Shippings.get_shipping_carrier!(shipping_carrier.id) == shipping_carrier
    end

    test "create_shipping_carrier/1 with valid data creates a shipping_carrier" do
      assert {:ok, %ShippingCarrier{} = shipping_carrier} = Shippings.create_shipping_carrier(@valid_attrs)
      assert shipping_carrier.name == "some name"
    end

    test "create_shipping_carrier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shippings.create_shipping_carrier(@invalid_attrs)
    end

    test "update_shipping_carrier/2 with valid data updates the shipping_carrier" do
      shipping_carrier = shipping_carrier_fixture()
      assert {:ok, %ShippingCarrier{} = shipping_carrier} = Shippings.update_shipping_carrier(shipping_carrier, @update_attrs)
      assert shipping_carrier.name == "some updated name"
    end

    test "update_shipping_carrier/2 with invalid data returns error changeset" do
      shipping_carrier = shipping_carrier_fixture()
      assert {:error, %Ecto.Changeset{}} = Shippings.update_shipping_carrier(shipping_carrier, @invalid_attrs)
      assert shipping_carrier == Shippings.get_shipping_carrier!(shipping_carrier.id)
    end

    test "delete_shipping_carrier/1 deletes the shipping_carrier" do
      shipping_carrier = shipping_carrier_fixture()
      assert {:ok, %ShippingCarrier{}} = Shippings.delete_shipping_carrier(shipping_carrier)
      assert_raise Ecto.NoResultsError, fn -> Shippings.get_shipping_carrier!(shipping_carrier.id) end
    end

    test "change_shipping_carrier/1 returns a shipping_carrier changeset" do
      shipping_carrier = shipping_carrier_fixture()
      assert %Ecto.Changeset{} = Shippings.change_shipping_carrier(shipping_carrier)
    end
  end

  describe "shipping_options" do
    alias Ruzenkit.Shippings.ShippingOption

    @valid_attrs %{description: "some description", name: "some name", shipping_time: ~T[14:00:00]}
    @update_attrs %{description: "some updated description", name: "some updated name", shipping_time: ~T[15:01:01]}
    @invalid_attrs %{description: nil, name: nil, shipping_time: nil}

    def shipping_option_fixture(attrs \\ %{}) do
      {:ok, shipping_option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shippings.create_shipping_option()

      shipping_option
    end

    test "list_shipping_options/0 returns all shipping_options" do
      shipping_option = shipping_option_fixture()
      assert Shippings.list_shipping_options() == [shipping_option]
    end

    test "get_shipping_option!/1 returns the shipping_option with given id" do
      shipping_option = shipping_option_fixture()
      assert Shippings.get_shipping_option!(shipping_option.id) == shipping_option
    end

    test "create_shipping_option/1 with valid data creates a shipping_option" do
      assert {:ok, %ShippingOption{} = shipping_option} = Shippings.create_shipping_option(@valid_attrs)
      assert shipping_option.description == "some description"
      assert shipping_option.name == "some name"
      assert shipping_option.shipping_time == ~T[14:00:00]
    end

    test "create_shipping_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shippings.create_shipping_option(@invalid_attrs)
    end

    test "update_shipping_option/2 with valid data updates the shipping_option" do
      shipping_option = shipping_option_fixture()
      assert {:ok, %ShippingOption{} = shipping_option} = Shippings.update_shipping_option(shipping_option, @update_attrs)
      assert shipping_option.description == "some updated description"
      assert shipping_option.name == "some updated name"
      assert shipping_option.shipping_time == ~T[15:01:01]
    end

    test "update_shipping_option/2 with invalid data returns error changeset" do
      shipping_option = shipping_option_fixture()
      assert {:error, %Ecto.Changeset{}} = Shippings.update_shipping_option(shipping_option, @invalid_attrs)
      assert shipping_option == Shippings.get_shipping_option!(shipping_option.id)
    end

    test "delete_shipping_option/1 deletes the shipping_option" do
      shipping_option = shipping_option_fixture()
      assert {:ok, %ShippingOption{}} = Shippings.delete_shipping_option(shipping_option)
      assert_raise Ecto.NoResultsError, fn -> Shippings.get_shipping_option!(shipping_option.id) end
    end

    test "change_shipping_option/1 returns a shipping_option changeset" do
      shipping_option = shipping_option_fixture()
      assert %Ecto.Changeset{} = Shippings.change_shipping_option(shipping_option)
    end
  end
end
