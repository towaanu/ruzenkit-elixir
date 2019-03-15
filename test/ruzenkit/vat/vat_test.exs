defmodule Ruzenkit.VatTest do
  use Ruzenkit.DataCase

  alias Ruzenkit.Vat

  describe "vat_groups" do
    alias Ruzenkit.Vat.VatGroup

    @valid_attrs %{label: "some label", rate: 120.5}
    @update_attrs %{label: "some updated label", rate: 456.7}
    @invalid_attrs %{label: nil, rate: nil}

    def vat_group_fixture(attrs \\ %{}) do
      {:ok, vat_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vat.create_vat_group()

      vat_group
    end

    test "list_vat_groups/0 returns all vat_groups" do
      vat_group = vat_group_fixture()
      assert Vat.list_vat_groups() == [vat_group]
    end

    test "get_vat_group!/1 returns the vat_group with given id" do
      vat_group = vat_group_fixture()
      assert Vat.get_vat_group!(vat_group.id) == vat_group
    end

    test "create_vat_group/1 with valid data creates a vat_group" do
      assert {:ok, %VatGroup{} = vat_group} = Vat.create_vat_group(@valid_attrs)
      assert vat_group.label == "some label"
      assert vat_group.rate == 120.5
    end

    test "create_vat_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vat.create_vat_group(@invalid_attrs)
    end

    test "update_vat_group/2 with valid data updates the vat_group" do
      vat_group = vat_group_fixture()
      assert {:ok, %VatGroup{} = vat_group} = Vat.update_vat_group(vat_group, @update_attrs)
      assert vat_group.label == "some updated label"
      assert vat_group.rate == 456.7
    end

    test "update_vat_group/2 with invalid data returns error changeset" do
      vat_group = vat_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Vat.update_vat_group(vat_group, @invalid_attrs)
      assert vat_group == Vat.get_vat_group!(vat_group.id)
    end

    test "delete_vat_group/1 deletes the vat_group" do
      vat_group = vat_group_fixture()
      assert {:ok, %VatGroup{}} = Vat.delete_vat_group(vat_group)
      assert_raise Ecto.NoResultsError, fn -> Vat.get_vat_group!(vat_group.id) end
    end

    test "change_vat_group/1 returns a vat_group changeset" do
      vat_group = vat_group_fixture()
      assert %Ecto.Changeset{} = Vat.change_vat_group(vat_group)
    end
  end
end
