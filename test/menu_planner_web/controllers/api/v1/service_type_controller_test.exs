defmodule MenuPlannerWeb.Api.V1.ServiceTypeControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Menus.ServiceType

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    @tag :authorized_token
    test "lists all service_types", %{conn: conn} do
      %ServiceType{id: id} = insert(:service_type)

      conn = get(conn, Routes.api_v1_service_type_path(conn, :index))
      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end
end
