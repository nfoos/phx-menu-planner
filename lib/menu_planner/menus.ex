defmodule MenuPlanner.Menus do
  @moduledoc false
  import Ecto.Query, warn: false
  alias MenuPlanner.Repo

  alias MenuPlanner.Menus.{
    MealService,
    Menu,
    ServiceType
  }

  # Menu

  def list_menus do
    Repo.all(Menu)
  end

  def get_menu!(id), do: Repo.get!(Menu, id)

  def create_menu(attrs \\ %{}) do
    %Menu{}
    |> Menu.changeset(attrs)
    |> Repo.insert()
  end

  def update_menu(%Menu{} = menu, attrs) do
    menu
    |> Menu.changeset(attrs)
    |> Repo.update()
  end

  def change_menu(%Menu{} = menu, attrs \\ %{}) do
    Menu.changeset(menu, attrs)
  end

  # ServiceType

  def create_service_type!(name) do
    Repo.insert!(%ServiceType{name: name}, on_conflict: :nothing)
  end

  def list_service_types do
    ServiceType
    |> Repo.all()
  end

  # MealService

  def list_meal_services do
    MealService
    |> Repo.all()
    |> preload_meal_services()
  end

  def fetch_meal_service(id) do
    case Repo.get(MealService, id) do
      nil -> {:error, :not_found}
      meal_service -> {:ok, preload_meal_services(meal_service)}
    end
  end

  def preload_meal_services(meal_services) do
    meal_services
    |> Repo.preload([:menu, :service_type, :menu_items])
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
