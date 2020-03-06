defmodule MenuPlannerWeb.Api.V1.AuthController do
  use MenuPlannerWeb, :controller

  alias MenuPlannerWeb.Auth.Guardian

  action_fallback MenuPlannerWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:created)
        |> render("login.json", %{user: user, token: token})

      {:error, _reason} ->
        {:error, :unauthorized}
    end
  end
end
