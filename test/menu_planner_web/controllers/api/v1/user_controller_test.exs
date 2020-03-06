defmodule MenuPlannerWeb.Api.V1.UserControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Accounts.User

  @create_attrs %{email: "some email", name: "some name"}
  @update_attrs %{email: "some updated email", name: "some updated name"}
  @invalid_attrs %{email: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :authorized_token
    test "lists all users", %{conn: conn, user: %User{id: id}} do
      conn = get(conn, Routes.api_v1_user_path(conn, :index))
      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end

  describe "create user" do
    @tag :authorized_token
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
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
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.api_v1_user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
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
