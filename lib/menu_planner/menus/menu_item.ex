defmodule MenuPlanner.Menus.MenuItem do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias MenuPlanner.Menus.MealService

  schema "menu_items" do
    field :name, :string

    belongs_to :meal_service, MealService

    timestamps()
  end

  @doc false
  def changeset(menu_item, attrs) do
    menu_item
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name, :meal_service_id])
  end
end
