defmodule MenuPlannerWeb.Api.V1.MenuItemView do
  use MenuPlannerWeb, :view

  def render("menu_item.json", %{menu_item: menu_item}) do
    %{
      id: menu_item.id,
      name: menu_item.name,
      inserted_at: NaiveDateTime.to_string(menu_item.inserted_at),
      updated_at: NaiveDateTime.to_string(menu_item.updated_at)
    }
  end
end
