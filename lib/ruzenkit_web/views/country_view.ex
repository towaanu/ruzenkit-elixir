defmodule RuzenkitWeb.CountryView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.CountryView

  def render("index.json", %{countries: countries}) do
    %{data: render_many(countries, CountryView, "country.json")}
  end

  def render("show.json", %{country: country}) do
    %{data: render_one(country, CountryView, "country.json")}
  end

  def render("country.json", %{country: country}) do
    %{id: country.id,
      english_name: country.english_name,
      local_name: country.local_name,
      short_iso_code: country.short_iso_code,
      long_iso_code: country.long_iso_code}
  end
end
