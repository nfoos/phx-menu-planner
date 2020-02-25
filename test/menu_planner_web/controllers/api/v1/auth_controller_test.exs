defmodule MenuPlannerWeb.Api.V1.AuthControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Accounts.User

  @pass "123456"

  setup do
    {:ok, user: insert(:user, password_hash: Pbkdf2.hash_pwd_salt(@pass))}
  end

  test "valid email and pass", %{conn: conn, user: %User{email: email}} do
    conn = post(conn, Routes.api_v1_auth_path(conn, :login), email: email, password: @pass)
    assert %{"email" => ^email, "token" => _token} = json_response(conn, 201)
  end

  test "invalid pass", %{conn: conn, user: %User{email: email}} do
    conn = post(conn, Routes.api_v1_auth_path(conn, :login), email: email, password: "invalid")
    assert json_response(conn, 401) == "Unauthorized"
  end

  test "invalid email", %{conn: conn} do
    conn = post(conn, Routes.api_v1_auth_path(conn, :login), email: "invalid", password: "invalid")
    assert json_response(conn, 401) == "Unauthorized"
  end
end
