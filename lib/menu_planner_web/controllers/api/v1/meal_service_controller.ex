defmodule MenuPlannerWeb.Api.V1.MealServiceController do
  use MenuPlannerWeb, :controller
  use PhoenixSwagger

  alias MenuPlanner.Menus
  alias MenuPlanner.Menus.MealService

  action_fallback MenuPlannerWeb.FallbackController

  def swagger_definitions do
    # coveralls-ignore-start
    %{
      MealService:
        swagger_schema do
          title("MealService")
          description("A meal service")

          properties do
            id(:integer, "Meal service ID", example: 1)
            name(:string, "Meal service name", example: "Taco Tuesday")
            date(:string, "Meal service date", format: :date, example: "2020-05-14")
            service_type_id(:integer, "Service type ID", example: 1)
            service_type(Schema.ref(:ServiceType))

            inserted_at(:string, "Create timestamp",
              format: :datetime,
              example: "2020-03-08 16:53:19"
            )

            updated_at(:string, "Update timestamp",
              format: :datetime,
              example: "2020-03-08 16:53:19"
            )
          end
        end,
      MealServiceParams:
        swagger_schema do
          title("MealServiceParams")
          description("Meal service parameters")

          properties do
            name(:string, "Meal service name", required: true, example: "Taco Tuesday")

            date(:string, "Meal service date",
              format: :date,
              required: true,
              example: "2020-05-15"
            )

            service_type_id(:integer, "Service type ID", required: true, example: 1)
          end
        end,
      MealServiceRequest:
        swagger_schema do
          title("MealServiceRequest")
          description("Request body for creating or updating a meal service")
          property(:meal_service, Schema.ref(:MealServiceParams))
        end,
      MealServiceResponse:
        swagger_schema do
          title("MealServiceResponse")
          description("Response schema for single meal service")
          property(:data, Schema.ref(:MealService))
        end,
      MealServicesResponse:
        swagger_schema do
          title("MealServicesReponse")
          description("Response schema for multiple meal services")
          property(:data, Schema.array(:MealService))
        end
    }

    # coveralls-ignore-stop
  end

  swagger_path :index do
    # coveralls-ignore-start
    summary("List meal services")
    description("Get a list of all meal services")
    security([%{Bearer: []}])
    response(200, "OK", Schema.ref(:MealServicesResponse))
    # coveralls-ignore-stop
  end

  def index(conn, _params) do
    meal_services = Menus.list_meal_services()
    render(conn, "index.json", meal_services: meal_services)
  end

  swagger_path :create do
    # coveralls-ignore-start
    summary("Create meal service")
    description("Create a new meal service")
    security([%{Bearer: []}])
    parameter(:meal_service, :body, Schema.ref(:MealServiceRequest), "Meal service params")
    response(201, "Created", Schema.ref(:MealServiceResponse))
    # coveralls-ignore-stop
  end

  def create(conn, %{"meal_service" => meal_service_params}) do
    with {:ok, %MealService{} = meal_service} <- Menus.create_meal_service(meal_service_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_meal_service_path(conn, :show, meal_service))
      |> show_meal_service(meal_service)
    end
  end

  swagger_path :show do
    # coveralls-ignore-start
    summary("Show meal service")
    description("Show a meal service")
    security([%{Bearer: []}])
    parameter(:id, :path, :integer, "Meal service ID", required: true)
    response(200, "OK", Schema.ref(:MealServiceResponse))
    response(404, "Not Found")
    # coveralls-ignore-stop
  end

  def show(conn, %{"id" => id}) do
    meal_service = Menus.get_meal_service!(id)
    show_meal_service(conn, meal_service)
  end

  swagger_path :update do
    # coveralls-ignore-start
    put("/api/v1/meal_services/{id}")
    summary("Update meal service")
    description("Update a meal service")
    security([%{Bearer: []}])

    parameters do
      id(:path, :integer, "Meal service ID", required: true)
      meal_service(:body, Schema.ref(:MealServiceRequest), "Meal service params")
    end

    response(200, "OK", Schema.ref(:MealServiceResponse))
    response(404, "Not Found")
    # coveralls-ignore-stop
  end

  def update(conn, %{"id" => id, "meal_service" => meal_service_params}) do
    meal_service = Menus.get_meal_service!(id)

    with {:ok, %MealService{} = meal_service} <-
           Menus.update_meal_service(meal_service, meal_service_params) do
      show_meal_service(conn, meal_service)
    end
  end

  defp show_meal_service(conn, %MealService{} = meal_service) do
    render(conn, "show.json", meal_service: Menus.preload_meal_services(meal_service))
  end
end
