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

  pipeline :graphql do
    plug Ruzenkit.Accounts.AuthContext
    # plug CORSPlug, origin: "*"
  end

  scope "/", RuzenkitWeb do
    pipe_through :browser

    get "/", PageController, :index
    # , except: [:new, :edit]
    # resources "/products", ProductController
    # resources "/configurable_options", ConfigurableOptionController
    # resources "/configurable_products", ConfigurableProductController
  end

  scope "/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: RuzenkitWeb.Graphql.Schema,
      json_codec: Jason
  end

  scope "/graphiql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug.GraphiQL,
      schema: RuzenkitWeb.Graphql.Schema,
      interface: :simple,
      json_codec: Jason
  end

  # Other scopes may use custom stacks.
  # scope "/api", RuzenkitWeb do
  #   pipe_through :api
  # end
end
