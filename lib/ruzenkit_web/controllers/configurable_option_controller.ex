defmodule RuzenkitWeb.ConfigurableOptionController do
  use RuzenkitWeb, :controller

  alias Ruzenkit.Products
  alias Ruzenkit.Products.ConfigurableOption

  action_fallback RuzenkitWeb.FallbackController

  def index(conn, _params) do
    configurable_options = Products.list_configurable_options()
    render(conn, "index.json", configurable_options: configurable_options)
  end

  def create(conn, %{"configurable_option" => configurable_option_params}) do
    with {:ok, %ConfigurableOption{} = configurable_option} <- Products.create_configurable_option(configurable_option_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.configurable_option_path(conn, :show, configurable_option))
      |> render("show.json", configurable_option: configurable_option)
    end
  end

  def show(conn, %{"id" => id}) do
    configurable_option = Products.get_configurable_option!(id)
    render(conn, "show.json", configurable_option: configurable_option)
  end

  def update(conn, %{"id" => id, "configurable_option" => configurable_option_params}) do
    configurable_option = Products.get_configurable_option!(id)

    with {:ok, %ConfigurableOption{} = configurable_option} <- Products.update_configurable_option(configurable_option, configurable_option_params) do
      render(conn, "show.json", configurable_option: configurable_option)
    end
  end

  def delete(conn, %{"id" => id}) do
    configurable_option = Products.get_configurable_option!(id)

    with {:ok, %ConfigurableOption{}} <- Products.delete_configurable_option(configurable_option) do
      send_resp(conn, :no_content, "")
    end
  end
end
