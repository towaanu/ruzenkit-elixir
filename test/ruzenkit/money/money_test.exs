defmodule Ruzenkit.MoneyTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Money

  describe "currencies" do
    alias Ruzenkit.Money.Currency

    @valid_attrs %{code: "EUR", name: "euro", sign: "€"}
    @update_attrs %{code: "USD", name: "US dollar", sign: "$"}
    @invalid_attrs %{code: nil, name: nil, sign: nil}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Money.create_currency()

      currency
    end

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Money.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Money.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Money.create_currency(@valid_attrs)
      assert currency.code == "EUR"
      assert currency.name == "euro"
      assert currency.sign == "€"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Money.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Money.update_currency(currency, @update_attrs)
      assert currency.code == "USD"
      assert currency.name == "US dollar"
      assert currency.sign == "$"
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Money.update_currency(currency, @invalid_attrs)
      assert currency == Money.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Money.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Money.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Money.change_currency(currency)
    end
  end
end
