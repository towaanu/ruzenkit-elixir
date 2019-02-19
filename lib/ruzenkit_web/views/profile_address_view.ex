defmodule RuzenkitWeb.ProfileAddressView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ProfileAddressView

  def render("index.json", %{profile_addresses: profile_addresses}) do
    %{data: render_many(profile_addresses, ProfileAddressView, "profile_address.json")}
  end

  def render("show.json", %{profile_address: profile_address}) do
    %{data: render_one(profile_address, ProfileAddressView, "profile_address.json")}
  end

  def render("profile_address.json", %{profile_address: profile_address}) do
    %{id: profile_address.id,
      is_default: profile_address.is_default}
  end
end
