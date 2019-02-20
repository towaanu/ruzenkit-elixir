# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ruzenkit.Repo.insert!(%Ruzenkit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ruzenkit.Accounts.User
alias Ruzenkit.Accounts.Credential
alias Ruzenkit.Accounts
alias Ruzenkit.Addresses
alias Ruzenkit.Vat
alias Ruzenkit.Money
alias Ruzenkit.Products

# User

{:ok, france_country} = Addresses.create_country(%{
  english_name: "france",
  local_name: "france",
  short_iso_code: "FR",
  long_iso_code: "FRA"
})


new_admin = %{
  is_admin: true,
  credential: %{
    password: "antoine"
  },
  profile: %{
    email: "antoine@ruzenkit.com",
    first_name: "Antoine",
    last_name: "Muller",
    profile_addresses: [%{
      is_default: true,
      address: %{
        first_name: "Antoine",
        last_name: "Muller",
        city: "Palette town",
        zip_code: "34000",
        street: "rue du poney",
        country_id: france_country.id
      }
    }]
  }
}
Accounts.create_user(new_admin)


# product
{:ok, vat_group} = Vat.create_vat_group(%{
  label: "TVA normal",
  rate: 20,
  country_id: france_country.id
})

{:ok, configurable_option} = Products.create_configurable_option(%{label: "Size"})

Products.create_configurable_item_option(%{
  label: "Small",
  short_label: "S",
  configurable_option_id: configurable_option.id
})

Products.create_configurable_item_option(%{
  label: "Medium",
  short_label: "M",
  configurable_option_id: configurable_option.id
})

Products.create_configurable_item_option(%{
  label: "Large",
  short_label: "L",
  configurable_option_id: configurable_option.id
})

Products.create_configurable_item_option(%{
  label: "XLarge",
  short_label: "XL",
  configurable_option_id: configurable_option.id
})

Products.create_configurable_item_option(%{
  label: "XXLarge",
  short_label: "XXL",
  configurable_option_id: configurable_option.id
})

{:ok, euro_currency} = Money.create_currency(%{name: "Euro", code: "EUR", sign: "€"})
Money.create_currency(%{name: "US Dollar", code: "USD", sign: "$"})

Products.create_product(%{
  name: "Foo",
  sku: "foo",
  description: "The foo product",
  vat_group_id: vat_group.id,
  price: %{
    amount: 25.5,
    currency_id: euro_currency.id
  }
})

{:ok, le_slip_product} Products.create_product(%{
  name: "Le slip",
  sku: "le_slip",
  description: "Un slip",
  vat_group_id: vat_group.id,
  price: %{
    amount: 20,
    currency_id: euro_currency.id
  }
})
