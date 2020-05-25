defmodule MenuPlannerWeb.Api.V1.MealServiceView do
  use MenuPlannerWeb, :view

  alias MenuPlannerWeb.Api.V1.{
    MealServiceView,
    MenuItemView,
    MenuView,
    ServiceTypeView
  }

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
      menu_id: meal_service.menu_id,
      menu: render_one(meal_service.menu, MenuView, "menu.json"),
      service_type_id: meal_service.service_type_id,
      service_type: render_one(meal_service.service_type, ServiceTypeView, "service_type.json"),
      menu_items: render_many(meal_service.menu_items, MenuItemView, "menu_item.json"),
      inserted_at: NaiveDateTime.to_string(meal_service.inserted_at),
      updated_at: NaiveDateTime.to_string(meal_service.updated_at)
    }
  end
end
