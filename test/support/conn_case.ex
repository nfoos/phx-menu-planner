# credo:disable-for-this-file
defmodule MenuPlannerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use MenuPlannerWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import MenuPlannerWeb.ConnCase
      import MenuPlanner.Factory

      alias MenuPlannerWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint MenuPlannerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MenuPlanner.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MenuPlanner.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    {conn, user} =
      cond do
        tags[:authenticated_user] ->
          user = MenuPlanner.Factory.insert(:user)
          conn = Plug.Conn.assign(conn, :current_user, user)
          {conn, user}

        tags[:authorized_token] ->
          user = MenuPlanner.Factory.insert(:user)
          {:ok, _user, token} = MenuPlannerWeb.Auth.Guardian.create_token(user)
          conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)
          {conn, user}

        true ->
          {conn, nil}
      end

    {:ok, conn: conn, user: user}
  end
end
