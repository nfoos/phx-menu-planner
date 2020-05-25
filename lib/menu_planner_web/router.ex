defmodule MenuPlannerWeb.Router do
  use MenuPlannerWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MenuPlannerWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :token_auth do
    plug MenuPlannerWeb.Auth.Pipeline
  end

  scope "/", MenuPlannerWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
  end

  scope "/", MenuPlannerWeb do
    pipe_through [:browser, :authenticate_user]

    live_dashboard "/dashboard", metrics: MenuPlannerWeb.Telemetry

    resources "/menus", MenuController, except: [:delete]
    resources "/users", UserController, except: [:delete]
  end

  scope "/api", MenuPlannerWeb, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      post "/login", AuthController, :login
    end

    scope "/v1", Api.V1, as: :v1 do
      pipe_through :token_auth

      resources "/meal_services", MealServiceController, except: [:new, :edit, :delete]
      resources "/menus", MenuController, only: [:index]
      resources "/service_types", ServiceTypeController, only: [:index]
    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :menu_planner,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Menu Planner"
      },
      tags: [],
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description:
            "API Token must be provided via `Authorization: Bearer <api_token>` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"]
    }
  end
end
