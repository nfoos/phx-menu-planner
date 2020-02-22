defmodule MenuPlannerWeb.UserControllerTest do
  use MenuPlannerWeb.ConnCase

  @create_attrs %{email: "some email", name: "some name"}
  @update_attrs %{email: "some updated email", name: "some updated name"}
  @invalid_attrs %{email: nil, name: nil}

  describe "index" do
    @tag :authenticated_user
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    @tag :authenticated_user
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    @tag :authenticated_user
    test "redirects to show when data is valid", %{conn: conn} do
      create_conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.user_path(create_conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    @tag :authenticated_user
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    @tag :authenticated_user
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :authenticated_user
    test "redirects when data is valid", %{conn: conn, user: user} do
      update_conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(update_conn) == Routes.user_path(update_conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated email"
    end

    @tag :authenticated_user
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  defp create_user(_) do
    user = insert(:user, @create_attrs)
    {:ok, user: user}
  end
end
