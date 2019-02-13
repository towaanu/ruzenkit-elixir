defmodule RuzenkitWeb.ConfigurableOptionView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ConfigurableOptionView

  def render("index.json", %{configurable_options: configurable_options}) do
    %{data: render_many(configurable_options, ConfigurableOptionView, "configurable_option.json")}
  end

  def render("show.json", %{configurable_option: configurable_option}) do
    %{data: render_one(configurable_option, ConfigurableOptionView, "configurable_option.json")}
  end

  def render("configurable_option.json", %{configurable_option: configurable_option}) do
    %{id: configurable_option.id,
      label: configurable_option.label}
  end
end
