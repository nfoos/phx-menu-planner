defmodule MenuPlannerWeb.Api.V1.MenuControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Menus.Menu

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    @tag :authorized_token
    test "lists all menus", %{conn: conn} do
      %Menu{id: id} = insert(:menu)

      conn = get(conn, Routes.api_v1_menu_path(conn, :index))
      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end
end
