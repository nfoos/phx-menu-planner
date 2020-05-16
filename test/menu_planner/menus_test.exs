defmodule MenuPlanner.MenusTest do
  use MenuPlanner.DataCase

  alias MenuPlanner.Menus
  alias MenuPlanner.Menus.{MealService, ServiceType}
  alias MenuPlanner.Repo

  @invalid_attrs %{date: nil, name: nil, service_type_id: nil}

  describe "create_service_type!/1" do
    test "creates service type if it doesn't exist" do
      name = params_for(:service_type).name
      refute Repo.get_by(ServiceType, name: name)
      assert %ServiceType{} = Menus.create_service_type!(name)
      assert Repo.get_by(ServiceType, name: name)
    end

    test "does nothing if service type already exists" do
      %ServiceType{name: name} = insert(:service_type)
      assert %ServiceType{id: nil, name: ^name} = Menus.create_service_type!(name)
    end
  end

  describe "list_meal_services/0" do
    test "returns all meal_services" do
      meal_service = insert(:meal_service)
      assert Menus.list_meal_services() == [meal_service]
    end
  end

  describe "get_meal_service/1" do
    test "returns the meal_service with given id" do
      meal_service = insert(:meal_service)
      assert Menus.get_meal_service!(meal_service.id) == meal_service
    end
  end

  describe "create_meal_service/1" do
    test "with valid data creates a meal_service" do
      create_params = params_with_assocs(:meal_service)
      assert {:ok, %MealService{} = meal_service} = Menus.create_meal_service(create_params)
      assert meal_service.date == create_params.date
      assert meal_service.name == create_params.name
      assert meal_service.service_type_id == create_params.service_type_id
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menus.create_meal_service(@invalid_attrs)
    end
  end

  describe "update_meal_service/2" do
    test "with valid data updates the meal_service" do
      meal_service = insert(:meal_service)
      update_params = params_with_assocs(:meal_service)

      assert {:ok, %MealService{} = meal_service} =
               Menus.update_meal_service(meal_service, update_params)

      assert meal_service.date == update_params.date
      assert meal_service.name == update_params.name
      assert meal_service.service_type_id == update_params.service_type_id
    end

    test "with invalid data returns error changeset" do
      meal_service = insert(:meal_service)
      assert {:error, %Ecto.Changeset{}} = Menus.update_meal_service(meal_service, @invalid_attrs)
      assert meal_service == Menus.get_meal_service!(meal_service.id)
    end
  end

  describe "change_meal_service/1" do
    test "returns a meal_service changeset" do
      meal_service = insert(:meal_service)
      assert %Ecto.Changeset{} = Menus.change_meal_service(meal_service)
    end
  end
end
