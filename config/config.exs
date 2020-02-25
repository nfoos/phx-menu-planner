# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :menu_planner,
  ecto_repos: [MenuPlanner.Repo]

# Configures the endpoint
config :menu_planner, MenuPlannerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Rlfv5qwB1IAXd/b6KyYfLESOkhB52c3eJSVy/MJsi3dKFraYqjh5vKxImVp1J1oO",
  render_errors: [view: MenuPlannerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MenuPlanner.PubSub, adapter: Phoenix.PubSub.PG2]

config :menu_planner, MenuPlannerWeb.Auth.Guardian,
  issuer: "menu_planner",
  secret_key: "GVa41N8TYzvJuI36Csjt4bf+gsqidIXNiC9yhHgb2zzCv6KC8jvGhfMxPSeZuMzR"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
