defmodule RuzenkitWeb.ConfigurableItemOptionController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ConfigurableItemOption

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    configurable_item_options = Products.list_configurable_item_options()
    render(conn, "index.json", configurable_item_options: configurable_item_options)
  end

  def create(conn, %{"configurable_item_option" => configurable_item_option_params}) do
    with {:ok, %ConfigurableItemOption{} = configurable_item_option} <- Products.create_configurable_item_option(configurable_item_option_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.configurable_item_option_path(conn, :show, configurable_item_option))
      |> render("show.json", configurable_item_option: configurable_item_option)
    end
  end

  def show(conn, %{"id" => id}) do
    configurable_item_option = Products.get_configurable_item_option!(id)
    render(conn, "show.json", configurable_item_option: configurable_item_option)
  end

  def update(conn, %{"id" => id, "configurable_item_option" => configurable_item_option_params}) do
    configurable_item_option = Products.get_configurable_item_option!(id)

    with {:ok, %ConfigurableItemOption{} = configurable_item_option} <- Products.update_configurable_item_option(configurable_item_option, configurable_item_option_params) do
      render(conn, "show.json", configurable_item_option: configurable_item_option)
    end
  end

  def delete(conn, %{"id" => id}) do
    configurable_item_option = Products.get_configurable_item_option!(id)

    with {:ok, %ConfigurableItemOption{}} <- Products.delete_configurable_item_option(configurable_item_option) do
      send_resp(conn, :no_content, "")
    end
  end
end
