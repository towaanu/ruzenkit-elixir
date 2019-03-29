defmodule RuzenkitWeb.AddressesResolverTest do
  use RuzenkitWeb.ConnCase
  alias Ruzenkit.Addresses

  @create_country_attrs %{
    local_name: "France",
    english_name: "France",
    short_iso_code: "FR",
    long_iso_code: "FRA"
  }

  describe "countries resolver" do
    test "CreateCountry($country: CountryInput!) create new country", %{conn: conn} do
      query = """
        mutation CreateCountry($country: CountryInput!) {
          createCountry(country: $country) {
            id
            localName
            englishName
            shortIsoCode
            longIsoCode
          }
        }
      """

      res =
        conn
        |> post("/graphql", %{
          "operationName" => "",
          "query" => query,
          "variables" => %{country: @create_country_attrs}
        })

      assert %{
               "id" => id,
               "localName" => "France",
               "englishName" => "france",
               "shortIsoCode" => "FR",
               "longIsoCode" => "FRA"
             } = json_response(res, 200)["data"]["createCountry"]
    end
  end
end
