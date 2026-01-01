defmodule BackendWeb.ItemJSON do
  def show(%{item: item}) do
    %{
      id: item.id,
      name: item.name,
      sku: item.sku,
      unit: item.unit,
      inserted_at: item.inserted_at
    }
  end

  def index(%{items: items}) do
    Enum.map(items, &show(%{item: &1}))
  end
end

