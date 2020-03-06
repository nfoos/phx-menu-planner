defmodule MenuPlanner.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: MenuPlanner.Repo

  alias MenuPlanner.Accounts.User

  def user_factory do
    %User{
      name: sequence("Test User"),
      email: sequence(:email, &"test.user#{&1}@example.com")
    }
  end
end
