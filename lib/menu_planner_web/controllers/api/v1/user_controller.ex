defmodule MenuPlannerWeb.Api.V1.UserController do
  use MenuPlannerWeb, :controller
  use PhoenixSwagger

  alias MenuPlanner.Accounts
  alias MenuPlanner.Accounts.User

  action_fallback MenuPlannerWeb.FallbackController

  def swagger_definitions do
    # coveralls-ignore-start
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the app")

          properties do
            id(:integer, "User ID", example: 1)
            name(:string, "User name", example: "User Name")
            email(:string, "Email address", format: :email)

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
      UserParams:
        swagger_schema do
          title("UserParams")
          description("User parameters")

          properties do
            name(:string, "User name", required: true, example: "User Name")
            email(:string, "Email address", format: :email, required: true)
            password(:string, "Password", format: :password, example: "secret")
          end
        end,
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("Request body for creating or updating a user")
          property(:user, Schema.ref(:UserParams))
        end,
      UserResponse:
        swagger_schema do
          title("UserResponse")
          description("Response schema for single user")
          property(:data, Schema.ref(:User))
        end,
      UsersResponse:
        swagger_schema do
          title("UsersReponse")
          description("Response schema for multiple users")
          property(:data, Schema.array(:User))
        end
    }

    # coveralls-ignore-stop
  end

  swagger_path :index do
    # coveralls-ignore-start
    summary("List Users")
    description("Get a list of all users")
    security([%{Bearer: []}])
    response(200, "OK", Schema.ref(:UsersResponse))
    # coveralls-ignore-stop
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  swagger_path :create do
    # coveralls-ignore-start
    summary("Create User")
    description("Create a new user")
    security([%{Bearer: []}])
    parameter(:user, :body, Schema.ref(:UserRequest), "User params")
    response(201, "Created", Schema.ref(:UserResponse))
    # coveralls-ignore-stop
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  swagger_path :show do
    # coveralls-ignore-start
    summary("Show User")
    description("Show a user")
    security([%{Bearer: []}])
    parameter(:id, :path, :integer, "User ID", required: true)
    response(200, "OK", Schema.ref(:UserResponse))
    response(404, "Not Found")
    # coveralls-ignore-stop
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.fetch_user(id) do
      render(conn, "show.json", user: user)
    end
  end

  swagger_path :update do
    # coveralls-ignore-start
    put("/api/v1/users/{id}")
    summary("Update User")
    description("Update a user")
    security([%{Bearer: []}])

    parameters do
      id(:path, :integer, "User ID", required: true)
      user(:body, Schema.ref(:UserRequest), "User params")
    end

    response(200, "OK", Schema.ref(:UserResponse))
    response(404, "Not Found")
    # coveralls-ignore-stop
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- Accounts.fetch_user(id),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
