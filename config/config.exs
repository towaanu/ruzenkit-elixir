# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ruzenkit,
  ecto_repos: [Ruzenkit.Repo]

# Configures the endpoint
config :ruzenkit, RuzenkitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ahhdXXNxWMeQfGETMyh0rl1sa7rGTSY9jGqn3uI3yarUFSXvCFsnl8hXiQWNtSUM",
  render_errors: [view: RuzenkitWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ruzenkit.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ruzenkit, Ruzenkit.Accounts.Guardian,
  issuer: "ruzenkit",
  secret_key: "hello",
  ttl: {60, :seconds}
  # secret_key: "VAx8SCRQM46MByemu6/xLePFefgS+3eJqv1N/g9dIy80WdhWSGkh8W086uycyPkq"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
