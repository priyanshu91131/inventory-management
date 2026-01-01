defmodule BackendWeb.ItemController do
  use BackendWeb, :controller

  alias Backend.Inventory

  # GET /api/items
  def index(conn, _params) do
    items = Inventory.list_items_with_stock()

    json(conn, %{data: items})
  end

  # POST /api/items
  def create(conn, %{"item" => item_params}) do
  case Inventory.create_item(item_params) do
    {:ok, item} ->
      json(conn, %{
        data: %{
          id: item.id,
          name: item.name,
          sku: item.sku,
          unit: item.unit,
          current_stock: 0
        }
      })

    {:error, changeset} ->
      IO.inspect(changeset.errors, label: "ITEM CHANGESET ERRORS")

      conn
      |> put_status(:unprocessable_entity)
      |> json(%{
        errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
      })
  end
end
end
