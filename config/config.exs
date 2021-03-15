# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :stadler_no, StadlerNoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ms+cXtrCvpp0vwCBvhergEuvrfM7m0amWngP2g2fJ5WNGyRjePNg+FX9t6t87r2h",
  render_errors: [view: StadlerNoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: StadlerNo.PubSub,
  live_view: [signing_salt: "v2QKH8OV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


import_config "#{Mix.env()}.exs"

