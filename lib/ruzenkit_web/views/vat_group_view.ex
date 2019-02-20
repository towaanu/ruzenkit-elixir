defmodule RuzenkitWeb.VatGroupView do
  use RuzenkitWeb, :view
  alias RuzenkitWeb.VatGroupView

  def render("index.json", %{vat_groups: vat_groups}) do
    %{data: render_many(vat_groups, VatGroupView, "vat_group.json")}
  end

  def render("show.json", %{vat_group: vat_group}) do
    %{data: render_one(vat_group, VatGroupView, "vat_group.json")}
  end

  def render("vat_group.json", %{vat_group: vat_group}) do
    %{id: vat_group.id,
      rate: vat_group.rate,
      label: vat_group.label}
  end
end
