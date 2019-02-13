defmodule RuzenkitWeb.PageController do
  use RuzenkitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
