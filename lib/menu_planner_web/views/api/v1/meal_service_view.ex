defmodule MenuPlannerWeb.Api.V1.MealServiceView do
  use MenuPlannerWeb, :view
  alias MenuPlannerWeb.Api.V1.MealServiceView

  def render("index.json", %{meal_services: meal_services}) do
    %{data: render_many(meal_services, MealServiceView, "meal_service.json")}
  end

  def render("show.json", %{meal_service: meal_service}) do
    %{data: render_one(meal_service, MealServiceView, "meal_service.json")}
  end

  def render("meal_service.json", %{meal_service: meal_service}) do
    %{
      id: meal_service.id,
      name: meal_service.name,
      date: meal_service.date,
      service_type_id: meal_service.service_type_id,
      inserted_at: NaiveDateTime.to_string(meal_service.inserted_at),
      updated_at: NaiveDateTime.to_string(meal_service.updated_at)
    }
  end
end
