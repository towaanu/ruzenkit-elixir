defmodule RuzenkitWeb.ProfileView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ProfileView

  def render("index.json", %{profile: profile}) do
    %{data: render_many(profile, ProfileView, "profile.json")}
  end

  def render("show.json", %{profile: profile}) do
    %{data: render_one(profile, ProfileView, "profile.json")}
  end

  def render("profile.json", %{profile: profile}) do
    %{id: profile.id,
      first_name: profile.first_name,
      last_name: profile.last_name,
      email: profile.email}
  end
end
