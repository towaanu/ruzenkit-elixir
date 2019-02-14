defmodule RuzenkitWeb.ConfigurableItemOptionView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.ConfigurableItemOptionView

  def render("index.json", %{configurable_item_options: configurable_item_options}) do
    %{data: render_many(configurable_item_options, ConfigurableItemOptionView, "configurable_item_option.json")}
  end

  def render("show.json", %{configurable_item_option: configurable_item_option}) do
    %{data: render_one(configurable_item_option, ConfigurableItemOptionView, "configurable_item_option.json")}
  end

  def render("configurable_item_option.json", %{configurable_item_option: configurable_item_option}) do
    %{id: configurable_item_option.id,
      label: configurable_item_option.label,
      short_label: configurable_item_option.short_label}
  end
end
