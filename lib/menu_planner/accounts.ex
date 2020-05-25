defmodule MenuPlanner.Accounts do
  @moduledoc false
  import Ecto.Query, warn: false
  alias MenuPlanner.Repo

  alias MenuPlanner.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_by_email_and_pass(email, pass) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
