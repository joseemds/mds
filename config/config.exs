# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mds,
  ecto_repos: [Mds.Repo]

# Configures the endpoint
config :mds, MdsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7o0uA0m7HUBodqx0PYvMtJBVYyr+46BwX5Dc6YOD0wuvez+Kv2LbjiV4eP9AYxrf",
  render_errors: [view: MdsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Mds.PubSub,
  live_view: [signing_salt: "PmP8GYFJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pre_commit,
  commands: ["test", "credo"],
  verbose: true

config :mds, Mds.Guardian,
  issuer: "mds",
  secret_key: "v27UZB2N2ATNn2otf6i0ce7QCo1W1uXzmcIGCm3LGCcerxDfxjugv/WJw5tHro1J"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
