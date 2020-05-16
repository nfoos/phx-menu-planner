defmodule MenuPlanner.Menus.ServiceType do
  @moduledoc false
  use Ecto.Schema

  schema "service_types" do
    field :name, :string

    timestamps()
  end
end
