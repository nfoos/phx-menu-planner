import Config

config :menu_planner, MenuPlannerWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("HOST"), port: 443],
  check_origin: ["//" <> System.get_env("HOST")]
