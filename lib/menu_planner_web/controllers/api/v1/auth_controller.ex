defmodule MenuPlannerWeb.Api.V1.AuthController do
  use MenuPlannerWeb, :controller
  use PhoenixSwagger

  alias MenuPlannerWeb.Auth.Guardian

  action_fallback MenuPlannerWeb.FallbackController

  def swagger_definitions do
    # coveralls-ignore-start
    %{
      LoginParams:
        swagger_schema do
          title("LoginParams")
          description("Login parameters")

          properties do
            email(:string, "Email", format: :email, required: true)
            password(:string, "Password", format: :password, required: true, example: "secret")
          end
        end,
      LoginResponse:
        swagger_schema do
          title("LoginResponse")
          description("Response schema for successful login")

          properties do
            email(:string, "Email", format: :email)

            token(:string, "Bearer token",
              example:
                "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJtZW51X3BsYW5uZXIiLCJleHAiOjE1ODYwMTk2MDMsImlhdCI6MTU4MzYwMDQwMywiaXNzIjoibWVudV9wbGFubmVyIiwianRpIjoiYjU0NmI3YzUtNzlmMy00ZTBjLTkzOTEtZWI0MzM0Mjg2MjM2IiwibmJmIjoxNTgzNjAwNDAyLCJzdWIiOiIxIiwidHlwIjoiYWNjZXNzIn0.t4PVJ3U8-ViwY8GnD2vjqgcXb8OPICLisCQVDMUv-1t0gvcuLZxNUucy6A9XRsH-hMxBMaad36OW7TXVAqiyqw"
            )
          end
        end
    }

    # coveralls-ignore-stop
  end

  swagger_path :login do
    # coveralls-ignore-start
    summary("Login")
    description("Authenticate a user and receive a Bearer token")
    parameter(:login, :body, Schema.ref(:LoginParams), "Login params")
    response(201, "Success", Schema.ref(:LoginResponse))
    # coveralls-ignore-stop
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:created)
        |> render("login.json", %{user: user, token: token})

      {:error, _reason} ->
        {:error, :unauthorized}
    end
  end
end
