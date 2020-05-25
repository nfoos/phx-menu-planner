defmodule MenuPlanner.Menus.Menu do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "menus" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(menu, attrs) do
    menu
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
