defmodule MenuPlanner.Menus.MealService do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias MenuPlanner.Menus.{MenuItem, ServiceType}

  schema "meal_services" do
    field :date, :date
    field :name, :string

    belongs_to :service_type, ServiceType
    has_many :menu_items, MenuItem, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(meal_service, attrs) do
    meal_service
    |> cast(attrs, [:name, :date, :service_type_id])
    |> validate_required([:name, :date, :service_type_id])
    |> cast_assoc(:menu_items)
    |> unique_constraint([:date, :service_type_id])
    |> foreign_key_constraint(:service_type_id)
  end
end
