defmodule MenuPlannerWeb.Api.V1.MenuController do
  use MenuPlannerWeb, :controller
  use PhoenixSwagger

  alias MenuPlanner.Menus

  action_fallback MenuPlannerWeb.FallbackController

  def swagger_definitions do
    # coveralls-ignore-start
    %{
      Menu:
        swagger_schema do
          title("Menu")
          description("A menu")

          properties do
            id(:integer, "menu ID", example: 1)
            name(:string, "menu name", example: "Test Menu")
          end
        end,
      MenusResponse:
        swagger_schema do
          title("MenusReponse")
          description("Response schema for multiple menus")
          property(:data, Schema.array(:Menu))
        end
    }

    # coveralls-ignore-stop
  end

  swagger_path :index do
    # coveralls-ignore-start
    summary("List menus")
    description("Get a list of all menus")
    security([%{Bearer: []}])
    response(200, "OK", Schema.ref(:MenusResponse))
    # coveralls-ignore-stop
  end

  def index(conn, _params) do
    menus = Menus.list_menus()
    render(conn, "index.json", menus: menus)
  end
end
