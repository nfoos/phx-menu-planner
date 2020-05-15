defmodule MenuPlannerWeb.Api.V1.MealServiceControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Menus.MealService

  @invalid_attrs %{date: nil, name: nil, service_type_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    @tag :authorized_token
    test "lists all meal_services", %{conn: conn} do
      %MealService{id: id} = insert(:meal_service)

      conn = get(conn, Routes.api_v1_meal_service_path(conn, :index))
      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end

  describe "create/2" do
    @tag :authorized_token
    test "renders meal_service when data is valid", %{conn: conn} do
      %{name: name} = create_params = params_with_assocs(:meal_service)
      create_path = Routes.api_v1_meal_service_path(conn, :create)

      conn = post(conn, create_path, meal_service: create_params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_meal_service_path(conn, :show, id))
      assert %{"id" => ^id, "name" => ^name} = json_response(conn, 200)["data"]
    end

    @tag :authorized_token
    test "renders errors when data is invalid", %{conn: conn} do
      create_path = Routes.api_v1_meal_service_path(conn, :create)

      conn = post(conn, create_path, meal_service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update/2" do
    @tag :authorized_token
    test "renders meal_service when data is valid", %{conn: conn} do
      %MealService{id: id} = insert(:meal_service)
      update_path = Routes.api_v1_meal_service_path(conn, :update, id)

      %{name: name} = update_params = params_with_assocs(:meal_service)

      conn = put(conn, update_path, meal_service: update_params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_meal_service_path(conn, :show, id))
      assert %{"id" => ^id, "name" => ^name} = json_response(conn, 200)["data"]
    end

    @tag :authorized_token
    test "renders errors when data is invalid", %{conn: conn} do
      %MealService{id: id} = insert(:meal_service)
      update_path = Routes.api_v1_meal_service_path(conn, :update, id)

      conn = put(conn, update_path, meal_service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
