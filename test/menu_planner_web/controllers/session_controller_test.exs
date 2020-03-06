defmodule MenuPlannerWeb.SessionControllerTest do
  use MenuPlannerWeb.ConnCase

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Log in"
    end
  end

  describe "session" do
    @pass "123456"

    setup do
      {:ok, user: insert(:user, password_hash: Pbkdf2.hash_pwd_salt(@pass))}
    end

    test "log in and out", %{conn: conn, user: user} do
      index_path = Routes.page_path(conn, :index)
      login_path = Routes.session_path(conn, :create)
      logout_path = Routes.session_path(conn, :delete)

      conn = get(conn, index_path)
      refute html_response(conn, 200) =~ user.name
      assert is_nil(conn.assigns.current_user)

      # log in
      conn = post(conn, login_path, session: %{email: user.email, password: @pass})
      assert get_flash(conn, :info) == "Welcome back!"
      assert redirected_to(conn) == index_path

      conn = get(conn, index_path)
      assert html_response(conn, 200) =~ user.name
      assert conn.assigns.current_user == user

      # log out
      conn = get(conn, logout_path)
      assert redirected_to(conn) == index_path

      conn = get(conn, index_path)
      refute html_response(conn, 200) =~ user.name
      assert is_nil(conn.assigns.current_user)
    end

    test "renders errors when login is invalid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{email: user.email, password: "invalid"}
        )

      assert get_flash(conn, :error) == "Invalid email/password combination"
      assert html_response(conn, 200) =~ "Log in"
      assert is_nil(conn.assigns.current_user)
    end
  end
end
