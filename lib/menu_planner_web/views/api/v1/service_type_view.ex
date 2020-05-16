defmodule MenuPlannerWeb.Api.V1.ServiceTypeView do
  use MenuPlannerWeb, :view
  alias MenuPlannerWeb.Api.V1.ServiceTypeView

  def render("index.json", %{service_types: service_types}) do
    %{data: render_many(service_types, ServiceTypeView, "service_type.json")}
  end

  def render("service_type.json", %{service_type: service_type}) do
    %{
      id: service_type.id,
      name: service_type.name
    }
  end
end
