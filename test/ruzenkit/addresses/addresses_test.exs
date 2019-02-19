defmodule Ruzenkit.AddressesTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Addresses

  describe "addresses" do
    alias Ruzenkit.Addresses.Address

    @valid_attrs %{building: "some building", city: "some city", extra_info: "some extra_info", first_name: "some first_name", floor: "some floor", last_name: "some last_name", place: "some place", zip_code: "some zip_code"}
    @update_attrs %{building: "some updated building", city: "some updated city", extra_info: "some updated extra_info", first_name: "some updated first_name", floor: "some updated floor", last_name: "some updated last_name", place: "some updated place", zip_code: "some updated zip_code"}
    @invalid_attrs %{building: nil, city: nil, extra_info: nil, first_name: nil, floor: nil, last_name: nil, place: nil, zip_code: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Addresses.create_address()

      address
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Addresses.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Addresses.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = Addresses.create_address(@valid_attrs)
      assert address.building == "some building"
      assert address.city == "some city"
      assert address.extra_info == "some extra_info"
      assert address.first_name == "some first_name"
      assert address.floor == "some floor"
      assert address.last_name == "some last_name"
      assert address.place == "some place"
      assert address.zip_code == "some zip_code"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Addresses.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, %Address{} = address} = Addresses.update_address(address, @update_attrs)
      assert address.building == "some updated building"
      assert address.city == "some updated city"
      assert address.extra_info == "some updated extra_info"
      assert address.first_name == "some updated first_name"
      assert address.floor == "some updated floor"
      assert address.last_name == "some updated last_name"
      assert address.place == "some updated place"
      assert address.zip_code == "some updated zip_code"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, @invalid_attrs)
      assert address == Addresses.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Addresses.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Addresses.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Addresses.change_address(address)
    end
  end

  describe "countries" do
    alias Ruzenkit.Addresses.Country

    @valid_attrs %{english_name: "some english_name", local_name: "some local_name", long_iso_code: "some long_iso_code", short_iso_code: "some short_iso_code"}
    @update_attrs %{english_name: "some updated english_name", local_name: "some updated local_name", long_iso_code: "some updated long_iso_code", short_iso_code: "some updated short_iso_code"}
    @invalid_attrs %{english_name: nil, local_name: nil, long_iso_code: nil, short_iso_code: nil}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Addresses.create_country()

      country
    end

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Addresses.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Addresses.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      assert {:ok, %Country{} = country} = Addresses.create_country(@valid_attrs)
      assert country.english_name == "some english_name"
      assert country.local_name == "some local_name"
      assert country.long_iso_code == "some long_iso_code"
      assert country.short_iso_code == "some short_iso_code"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Addresses.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = Addresses.update_country(country, @update_attrs)
      assert country.english_name == "some updated english_name"
      assert country.local_name == "some updated local_name"
      assert country.long_iso_code == "some updated long_iso_code"
      assert country.short_iso_code == "some updated short_iso_code"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Addresses.update_country(country, @invalid_attrs)
      assert country == Addresses.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Addresses.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Addresses.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Addresses.change_country(country)
    end
  end
end
