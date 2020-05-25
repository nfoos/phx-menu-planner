defmodule MenuPlanner.MenusTest do
  use MenuPlanner.DataCase

  alias MenuPlanner.Menus
  alias MenuPlanner.Repo

  alias MenuPlanner.Menus.{
    MealService,
    MenuItem,
    ServiceType
  }

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
      meal_service = insert(:meal_service) |> Menus.preload_meal_services()
      assert Menus.list_meal_services() == [meal_service]
    end
  end

  describe "fetch_meal_service/1" do
    test "returns the meal_service with given id" do
      meal_service = insert(:meal_service) |> Menus.preload_meal_services()
      assert Menus.fetch_meal_service(meal_service.id) == {:ok, meal_service}
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

    test "creates menu items" do
      menu_item_params = params_for(:menu_item)

      create_params =
        params_with_assocs(:meal_service)
        |> Map.put(:menu_items, [menu_item_params])

      assert {:ok, %MealService{} = meal_service} = Menus.create_meal_service(create_params)

      assert Repo.get_by(MenuItem, meal_service_id: meal_service.id, name: menu_item_params.name)
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
      meal_service = insert(:meal_service) |> Menus.preload_meal_services()
      assert {:error, %Ecto.Changeset{}} = Menus.update_meal_service(meal_service, @invalid_attrs)
      assert {:ok, meal_service} == Menus.fetch_meal_service(meal_service.id)
    end

    test "adds new menu items" do
      meal_service =
        insert(:meal_service)
        |> Menus.preload_meal_services()

      menu_item_params = params_for(:menu_item)

      refute Repo.get_by(MenuItem, meal_service_id: meal_service.id, name: menu_item_params.name)

      assert {:ok, %MealService{}} =
               Menus.update_meal_service(meal_service, %{
                 menu_items: [menu_item_params]
               })

      assert Repo.get_by(MenuItem, meal_service_id: meal_service.id, name: menu_item_params.name)
    end

    test "updates existing menu items" do
      menu_item = insert(:menu_item)
      new_name = menu_item.name <> " (updated)"
      {:ok, meal_service} = Menus.fetch_meal_service(menu_item.meal_service_id)

      assert Repo.get_by(MenuItem, id: menu_item.id, name: menu_item.name)
      refute Repo.get_by(MenuItem, id: menu_item.id, name: new_name)

      assert {:ok, %MealService{}} =
               Menus.update_meal_service(meal_service, %{
                 menu_items: [%{id: menu_item.id, name: new_name}]
               })

      refute Repo.get_by(MenuItem, id: menu_item.id, name: menu_item.name)
      assert Repo.get_by(MenuItem, id: menu_item.id, name: new_name)
    end

    test "deletes menu items" do
      menu_item = insert(:menu_item)
      {:ok, meal_service} = Menus.fetch_meal_service(menu_item.meal_service_id)

      assert Repo.get_by(MenuItem, id: menu_item.id, name: menu_item.name)

      assert {:ok, %MealService{}} =
               Menus.update_meal_service(meal_service, %{
                 menu_items: []
               })

      refute Repo.get_by(MenuItem, id: menu_item.id, name: menu_item.name)
    end
  end

  describe "change_meal_service/1" do
    test "returns a meal_service changeset" do
      meal_service = insert(:meal_service)
      assert %Ecto.Changeset{} = Menus.change_meal_service(meal_service)
    end
  end
end
