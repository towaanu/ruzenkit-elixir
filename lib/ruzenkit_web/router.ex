defmodule RuzenkitWeb.Router do
  use RuzenkitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RuzenkitWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/products", ProductController #, except: [:new, :edit]
  end

  forward "/graphql", Absinthe.Plug,
    schema: RuzenkitWeb.Graphql.Schema,
    json_codec: Jason

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: RuzenkitWeb.Graphql.Schema,
    interface: :simple,
    json_codec: Jason

  # Other scopes may use custom stacks.
  # scope "/api", RuzenkitWeb do
  #   pipe_through :api
  # end
end
