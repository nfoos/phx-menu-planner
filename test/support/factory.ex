defmodule MenuPlanner.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: MenuPlanner.Repo

  alias MenuPlanner.Accounts.User

  alias MenuPlanner.Menus.{
    MealService,
    MenuItem,
    ServiceType
  }

  def service_type_factory do
    %ServiceType{
      name: sequence("ServiceType")
    }
  end

  def meal_service_factory do
    %MealService{
      name: sequence("Meal"),
      date: Date.utc_today(),
      service_type: build(:service_type)
    }
  end

  def menu_item_factory do
    %MenuItem{
      name: sequence("Item"),
      meal_service: build(:meal_service)
    }
  end

  def user_factory do
    %User{
      name: sequence("Test User"),
      email: sequence(:email, &"test.user#{&1}@example.com")
    }
  end
end
