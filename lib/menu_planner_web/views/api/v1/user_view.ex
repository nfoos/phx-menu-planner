defmodule MenuPlannerWeb.Api.V1.UserView do
  use MenuPlannerWeb, :view
  alias MenuPlannerWeb.Api.V1.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      name: user.name,
      inserted_at: NaiveDateTime.to_string(user.inserted_at),
      updated_at: NaiveDateTime.to_string(user.updated_at),
    }
  end
end
