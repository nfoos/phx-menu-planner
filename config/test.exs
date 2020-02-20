use Mix.Config

# Configure your database
config :menu_planner, MenuPlanner.Repo,
  username: "admin",
  password: "admin",
  database: "menu_planner_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :menu_planner, MenuPlannerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :pbkdf2_elixir, :rounds, 1
