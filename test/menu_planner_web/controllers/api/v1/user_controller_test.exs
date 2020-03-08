defmodule MenuPlannerWeb.Api.V1.UserControllerTest do
  use MenuPlannerWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias MenuPlanner.Accounts.User

  @create_attrs %{email: "user1@example.com", name: "some name"}
  @update_attrs %{email: "user2@example.com", name: "some updated name"}
  @invalid_attrs %{email: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :authorized_token
    test "lists all users", %{conn: conn, user: %User{id: id}, swagger_schema: schema} do
      conn =
        conn
        |> get(Routes.api_v1_user_path(conn, :index))
        |> validate_resp_schema(schema, "UsersResponse")

      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end

  describe "create user" do
    @tag :authorized_token
    test "renders user when data is valid", %{conn: conn, swagger_schema: schema} do
      conn =
        conn
        |> post(Routes.api_v1_user_path(conn, :create), user: @create_attrs)
        |> validate_resp_schema(schema, "UserResponse")

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        conn
        |> get(Routes.api_v1_user_path(conn, :show, id))
        |> validate_resp_schema(schema, "UserResponse")

      assert %{
               "id" => id,
               "email" => "user1@example.com",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    @tag :authorized_token
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show user" do
    @tag :authorized_token
    test "returns 404 when user does not exist", %{conn: conn} do
      conn = get(conn, Routes.api_v1_user_path(conn, :show, 0))
      assert json_response(conn, 404) == "Not Found"
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :authorized_token
    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id} = user,
      swagger_schema: schema
    } do
      conn =
        conn
        |> put(Routes.api_v1_user_path(conn, :update, user), user: @update_attrs)
        |> validate_resp_schema(schema, "UserResponse")

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "user2@example.com",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    @tag :authorized_token
    test "returns 404 when user does not exist", %{conn: conn} do
      conn = put(conn, Routes.api_v1_user_path(conn, :update, 0), user: @update_attrs)
      assert json_response(conn, 404) == "Not Found"
    end

    @tag :authorized_token
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.api_v1_user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = insert(:user, @create_attrs)
    {:ok, user: user}
  end
end
