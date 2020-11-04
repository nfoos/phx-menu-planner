defmodule MenuPlannerWeb.Api.V1.MealServiceControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Menus.MealService

  @invalid_attrs %{date: nil, name: nil, service_type_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), menu: insert(:menu)}
  end

  describe "index/2" do
    @tag :authorized_token
    test "lists all meal_services", %{conn: conn, menu: menu} do
      %MealService{id: id} = insert(:meal_service, menu: menu)

      conn = get(conn, Routes.api_v1_menu_meal_service_path(conn, :index, menu))
      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end

  describe "create/2" do
    @tag :authorized_token
    test "renders meal_service when data is valid", %{conn: conn, menu: menu} do
      %{name: name} =
        create_params =
        params_with_assocs(:meal_service, menu: menu)
        |> Map.put(:menu_items, [params_for(:menu_item)])

      create_path = Routes.api_v1_meal_service_path(conn, :create)

      conn = post(conn, create_path, meal_service: create_params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_meal_service_path(conn, :show, id))
      assert %{"id" => ^id, "name" => ^name} = json_response(conn, 200)["data"]
    end

    @tag :authorized_token
    test "renders errors when data is invalid", %{conn: conn, menu: _menu} do
      create_path = Routes.api_v1_meal_service_path(conn, :create)

      conn = post(conn, create_path, meal_service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show/2" do
    @tag :authorized_token
    test "returns 404 when meal service does not exist", %{conn: conn, menu: _menu} do
      conn = get(conn, Routes.api_v1_meal_service_path(conn, :show, 0))
      assert json_response(conn, 404) == "Not Found"
    end
  end

  describe "update/2" do
    @tag :authorized_token
    test "renders meal_service when data is valid", %{conn: conn, menu: menu} do
      %MealService{id: id} = insert(:meal_service, menu: menu)
      update_path = Routes.api_v1_meal_service_path(conn, :update, id)

      %{name: name} = update_params = params_with_assocs(:meal_service)

      conn = put(conn, update_path, meal_service: update_params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_meal_service_path(conn, :show, id))
      assert %{"id" => ^id, "name" => ^name} = json_response(conn, 200)["data"]
    end

    @tag :authorized_token
    test "renders errors when data is invalid", %{conn: conn, menu: menu} do
      %MealService{id: id} = insert(:meal_service, menu: menu)
      update_path = Routes.api_v1_meal_service_path(conn, :update, id)

      conn = put(conn, update_path, meal_service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
