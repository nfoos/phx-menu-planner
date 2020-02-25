defmodule MenuPlannerWeb.Auth.Guardian do
  @moduledoc false
  use Guardian, otp_app: :menu_planner

  alias MenuPlanner.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def authenticate(email, pass) do
    with {:ok, user} <- Accounts.authenticate_by_email_and_pass(email, pass) do
      create_token(user)
    end
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
