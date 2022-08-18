# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ex_mon_api,
  ecto_repos: [ExMonApi.Repo]

config :ex_mon_api, env: config_env()

# Configures the endpoint
config :ex_mon_api, ExMonApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "49fEjGUCTHCiKrxJQGu3UhyANgEBBgvGIG1gAjnICuFOzKMC+ueMpx+3KM4CWGH0",
  render_errors: [view: ExMonApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ExMonApi.PubSub,
  live_view: [signing_salt: "NzPhc2HO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
