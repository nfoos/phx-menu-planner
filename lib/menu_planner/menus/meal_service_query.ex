defmodule MenuPlanner.Menus.MealServiceQuery do
  @moduledoc false
  import Ecto.Query, only: [from: 2, has_named_binding?: 2]

  alias MenuPlanner.Menus.MealService

  def meal_services, do: MealService

  # Filter

  def filtered_by(query \\ MealService, params) do
    Enum.reduce(params, query, fn {key, value}, query ->
      case key do
        :date_gte ->
          from meal_service in query,
            where: meal_service.date >= ^value

        :date_lte ->
          from meal_service in query,
            where: meal_service.date <= ^value

        :menu_id ->
          from meal_service in query,
            where: meal_service.menu_id == ^value
      end
    end)
  end

  # Order

  def ordered_by(query, params) do
    Enum.reduce(params, query, fn field, query ->
      case field do
        :date ->
          from meal_service in query,
            order_by: :date

        :service_type ->
          from meal_service in query,
            order_by: :service_type_id
      end
    end)
  end

  # Preload

  def include_service_type(query) do
    query = query |> join_service_type()

    from [_meal_service, service_type: service_type] in query,
      preload: [service_type: service_type]
  end

  def include_menu_items(query) do
    query = query |> join_menu_items()

    from [_meal_service, menu_items: menu_items] in query,
      preload: [menu_items: menu_items]
  end

  # Join

  defp join_service_type(query) do
    if has_named_binding?(query, :service_type) do
      query
    else
      from meal_service in query,
        join: service_type in assoc(meal_service, :service_type),
        as: :service_type
    end
  end

  defp join_menu_items(query) do
    if has_named_binding?(query, :menu_items) do
      query
    else
      from meal_service in query,
        left_join: menu_items in assoc(meal_service, :menu_items),
        as: :menu_items
    end
  end
end
