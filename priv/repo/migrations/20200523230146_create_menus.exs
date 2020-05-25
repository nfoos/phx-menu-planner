defmodule MenuPlanner.Repo.Migrations.CreateMenus do
  use Ecto.Migration

  def change do
    create table(:menus) do
      add(:name, :string, null: false)

      timestamps()
    end

    create(unique_index(:menus, [:name]))

    alter table(:meal_services) do
      add(:menu_id, references(:menus), null: false)
    end

    create(index(:meal_services, [:menu_id]))

    drop(index(:meal_services, [:date, :service_type_id]))
    create(unique_index(:meal_services, [:date, :service_type_id, :menu_id]))
  end
end
