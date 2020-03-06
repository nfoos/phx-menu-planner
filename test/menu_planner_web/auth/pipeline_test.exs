defmodule MenuPlannerWeb.Auth.PipelineTest do
  use MenuPlannerWeb.ConnCase, async: true

  alias MenuPlannerWeb.Auth

  defp pass_through(conn) do
    conn
    |> bypass_through(MenuPlannerWeb.Router, :token_auth)
    |> get("/")
  end

  test "request halts when no token provided", %{conn: conn} do
    conn =
      conn
      |> pass_through()

    assert response(conn, 401) == "unauthenticated"
    assert conn.halted
  end

  test "request halts when invalid token provided", %{conn: conn} do
    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer invalid")
      |> pass_through()

    assert response(conn, 401) == "invalid_token"
    assert conn.halted
  end

  test "request does not halt when valid token provided", %{conn: conn} do
    user = insert(:user)
    {:ok, _user, token} = Auth.Guardian.create_token(user)

    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer " <> token)
      |> pass_through()

    refute conn.halted
    assert Guardian.Plug.current_resource(conn) == user
  end
end
