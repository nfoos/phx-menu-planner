defmodule MenuPlanner.Repo.Migrations.CreateMenuItems do
  use Ecto.Migration

  def change do
    create table(:menu_items) do
      add :name, :string, null: false

      add :meal_service_id, references(:meal_services), null: false

      timestamps()
    end

    create index(:menu_items, [:meal_service_id])
    create unique_index(:menu_items, [:name, :meal_service_id])
  end
end
