defmodule MenuPlanner.Repo.Migrations.CreateMealServices do
  use Ecto.Migration

  def change do
    create table(:service_types) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:service_types, [:name])

    create table(:meal_services) do
      add :name, :string
      add :date, :date, null: false

      add :service_type_id, references(:service_types), null: false

      timestamps()
    end

    create unique_index(:meal_services, [:date, :service_type_id])
  end
end
