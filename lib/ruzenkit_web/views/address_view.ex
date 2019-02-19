defmodule RuzenkitWeb.AddressView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.AddressView

  def render("index.json", %{addresses: addresses}) do
    %{data: render_many(addresses, AddressView, "address.json")}
  end

  def render("show.json", %{address: address}) do
    %{data: render_one(address, AddressView, "address.json")}
  end

  def render("address.json", %{address: address}) do
    %{id: address.id,
      first_name: address.first_name,
      last_name: address.last_name,
      city: address.city,
      zip_code: address.zip_code,
      building: address.building,
      floor: address.floor,
      place: address.place,
      extra_info: address.extra_info}
  end
end
