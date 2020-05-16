defmodule MenuPlannerWeb.Api.V1.ServiceTypeController do
  use MenuPlannerWeb, :controller
  use PhoenixSwagger

  alias MenuPlanner.Menus

  action_fallback MenuPlannerWeb.FallbackController

  def swagger_definitions do
    # coveralls-ignore-start
    %{
      ServiceType:
        swagger_schema do
          title("ServiceType")
          description("A service type")

          properties do
            id(:integer, "service type ID", example: 1)
            name(:string, "service type name", example: "Lunch")
          end
        end,
      ServiceTypesResponse:
        swagger_schema do
          title("ServiceTypesReponse")
          description("Response schema for multiple service types")
          property(:data, Schema.array(:ServiceType))
        end
    }

    # coveralls-ignore-stop
  end

  swagger_path :index do
    # coveralls-ignore-start
    summary("List service types")
    description("Get a list of all service types")
    security([%{Bearer: []}])
    response(200, "OK", Schema.ref(:ServiceTypesResponse))
    # coveralls-ignore-stop
  end

  def index(conn, _params) do
    service_types = Menus.list_service_types()
    render(conn, "index.json", service_types: service_types)
  end
end
