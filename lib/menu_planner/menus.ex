defmodule MenuPlanner.Menus do
  @moduledoc false
  import Ecto.Query, warn: false
  alias MenuPlanner.Repo

  alias MenuPlanner.Menus.{MealService, ServiceType}

  def create_service_type!(name) do
    Repo.insert!(%ServiceType{name: name}, on_conflict: :nothing)
  end

  def list_service_types do
    ServiceType
    |> Repo.all()
  end

  def list_meal_services do
    MealService
    |> Repo.all()
    |> preload_meal_services()
  end

  def get_meal_service!(id) do
    MealService
    |> Repo.get!(id)
    |> preload_meal_services()
  end

  def preload_meal_services(meal_services) do
    meal_services
    |> Repo.preload(:service_type)
  end

  def create_meal_service(attrs \\ %{}) do
    %MealService{}
    |> MealService.changeset(attrs)
    |> Repo.insert()
  end

  def update_meal_service(%MealService{} = meal_service, attrs) do
    meal_service
    |> MealService.changeset(attrs)
    |> Repo.update()
  end

  def change_meal_service(%MealService{} = meal_service, attrs \\ %{}) do
    MealService.changeset(meal_service, attrs)
  end
end
