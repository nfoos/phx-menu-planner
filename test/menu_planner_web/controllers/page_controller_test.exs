defmodule MenuPlannerWeb.PageControllerTest do
  use MenuPlannerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Menu Planner!"
  end
end
