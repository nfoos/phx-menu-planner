defmodule MenuPlannerWeb.Router do
  use MenuPlannerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MenuPlannerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, except: [:delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MenuPlannerWeb do
  #   pipe_through :api
  # end
end
