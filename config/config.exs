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
config :logger, backends: [:console],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
# config :logger, backends: [:console, {LoggerFileBackend, :all_log}],
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ruzenkit, Ruzenkit.Accounts.Guardian,
  issuer: "ruzenkit",
  secret_key: "hello",
  ttl: {30, :days}
  # ttl: {600, :seconds}
  # secret_key: "VAx8SCRQM46MByemu6/xLePFefgS+3eJqv1N/g9dIy80WdhWSGkh8W086uycyPkq"

config :ruzenkit, Ruzenkit.Accounts.ForgotPasswordGuardian,
  issuer: "ruzenkit",
  secret_key: "hello",
  ttl: {1, :day}
  # ttl: {600, :seconds}
  # secret_key: "VAx8SCRQM46MByemu6/xLePFefgS+3eJqv1N/g9dIy80WdhWSGkh8W086uycyPkq"

# config :ruzenkit, Ruzenkit.Mailer,
#   adapter: Bamboo.SMTPAdapter,
#   server: "mailcow.ruzenkit.xyz",
#   hostname: "mailcow.ruzenkit.xyz",
#   port: 465,
#   username: "store@ruzenkit.com", # or {:system, "SMTP_USERNAME"}
#   password: "wkn7phlq", # or {:system, "SMTP_PASSWORD"}
#   tls: :if_available, # can be `:always` or `:never`
#   allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"], # or {:system, "ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
#   ssl: true, # can be `true`
#   retries: 1,
#   no_mx_lookups: false, # can be `true`
#   auth: :if_available # can be `always`. If your smtp relay requires authentication set it to `always`.


config :ruzenkit, Ruzenkit.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "localhost",
  hostname: "localhost",
  port: 1025,
  username: "your.name@your.domain", # or {:system, "SMTP_USERNAME"}
  password: "pa55word", # or {:system, "SMTP_PASSWORD"}
  tls: :if_available, # can be `:always` or `:never`
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"], # or {:system, "ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: false, # can be `true`
  retries: 1,
  no_mx_lookups: false, # can be `true`
  auth: :if_available # can be `always`. If your smtp relay requires authentication set it to `always`.


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
