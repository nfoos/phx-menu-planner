defmodule MenuPlannerWeb.Api.V1.AuthView do
  use MenuPlannerWeb, :view

  def render("login.json", %{user: user, token: token}) do
    %{
      email: user.email,
      token: token
    }
  end
end
