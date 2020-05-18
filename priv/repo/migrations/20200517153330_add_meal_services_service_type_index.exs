defmodule MenuPlanner.Repo.Migrations.AddMealServicesServiceTypeIndex do
  use Ecto.Migration

  def change do
    create index(:meal_services, [:service_type_id])
  end
end
