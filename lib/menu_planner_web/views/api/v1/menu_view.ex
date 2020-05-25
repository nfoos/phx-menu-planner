defmodule MenuPlannerWeb.Api.V1.MenuView do
  use MenuPlannerWeb, :view
  alias MenuPlannerWeb.Api.V1.MenuView

  def render("index.json", %{menus: menus}) do
    %{data: render_many(menus, MenuView, "menu.json")}
  end

  def render("menu.json", %{menu: menu}) do
    %{
      id: menu.id,
      name: menu.name
    }
  end
end
