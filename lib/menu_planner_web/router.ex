defmodule MenuPlannerWeb.Router do
  use MenuPlannerWeb, :router

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

    resources "/users", UserController, except: [:delete]
  end

  scope "/api", MenuPlannerWeb, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      post "/login", AuthController, :login
    end

    scope "/v1", Api.V1, as: :v1 do
      pipe_through :token_auth

      resources "/users", UserController, except: [:new, :edit, :delete]
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
      tags: [
        %{name: "User", description: "Operations related to Users"}
      ],
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
