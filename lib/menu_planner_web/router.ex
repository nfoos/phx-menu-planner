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
end
