defmodule MenuPlannerWeb.MenuControllerTest do
  use MenuPlannerWeb.ConnCase

  alias MenuPlanner.Menus.Menu
  alias Phoenix.HTML.Safe

  describe "index/2" do
    @tag :authenticated_user
    test "lists all menus", %{conn: conn} do
      menu = insert(:menu)
      conn = get(conn, Routes.menu_path(conn, :index))
      assert html_response(conn, 200) =~ "Menu List"
      assert html_response(conn, 200) =~ menu.name
    end
  end

  describe "new/2" do
    @tag :authenticated_user
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.menu_path(conn, :new))
      assert html_response(conn, 200) =~ "New Menu"
    end
  end

  describe "create/2" do
    @tag :authenticated_user
    test "redirects to show when data is valid", %{conn: conn} do
      create_params = params_for(:menu)
      create_conn = post(conn, Routes.menu_path(conn, :create), menu: create_params)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.menu_path(create_conn, :show, id)

      conn = get(conn, Routes.menu_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Menu"
      assert html_response(conn, 200) =~ create_params.name
    end

    @tag :authenticated_user
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.menu_path(conn, :create), menu: %{})
      assert html_response(conn, 200) =~ "New Menu"
      assert html_response(conn, 200) =~ Safe.to_iodata("can't be blank")
    end
  end

  describe "edit/2" do
    @tag :authenticated_user
    test "renders form for editing chosen menu", %{conn: conn} do
      menu = insert(:menu)
      conn = get(conn, Routes.menu_path(conn, :edit, menu))
      assert html_response(conn, 200) =~ "Edit Menu"
      assert html_response(conn, 200) =~ menu.name
    end
  end

  describe "update/2" do
    @tag :authenticated_user
    test "redirects when data is valid", %{conn: conn} do
      %Menu{id: id} = insert(:menu)
      %{name: name} = update_params = params_for(:menu)

      update_conn = put(conn, Routes.menu_path(conn, :update, id), menu: update_params)
      assert redirected_to(update_conn) == Routes.menu_path(update_conn, :show, id)

      conn = get(conn, Routes.menu_path(conn, :show, id))
      assert html_response(conn, 200) =~ name
    end

    @tag :authenticated_user
    test "renders errors when data is invalid", %{conn: conn} do
      %Menu{id: id} = insert(:menu)
      conn = put(conn, Routes.menu_path(conn, :update, id), menu: %{name: ""})
      assert html_response(conn, 200) =~ "Edit Menu"
      assert html_response(conn, 200) =~ Safe.to_iodata("can't be blank")
    end
  end
end
