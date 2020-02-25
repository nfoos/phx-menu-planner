defmodule MenuPlannerWeb.Auth.Pipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :menu_planner,
    error_handler: MenuPlannerWeb.Auth.ErrorHandler,
    module: MenuPlannerWeb.Auth.Guardian

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
