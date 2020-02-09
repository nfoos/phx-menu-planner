defmodule MenuPlanner.Repo do
  use Ecto.Repo,
    otp_app: :menu_planner,
    adapter: Ecto.Adapters.Postgres
end
