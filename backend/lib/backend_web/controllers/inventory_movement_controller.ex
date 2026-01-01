defmodule BackendWeb.InventoryMovementController do
  use BackendWeb, :controller
  alias Backend.Inventory

  # POST /api/movements
  def create(conn, %{"movement" => movement_params}) do
    case Inventory.record_movement(movement_params) do
      {:ok, movement} ->
        json(conn, %{
          data: %{
            id: movement.id,
            item_id: movement.item_id,
            quantity: movement.quantity,
            movement_type: movement.movement_type,
            inserted_at: movement.inserted_at
          }
        })

      {:error, reason} when is_binary(reason) ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, & &1)})
    end
  end

  def index(conn, %{"item_id" => item_id}) do
  movements = Inventory.list_movements_for_item(item_id)

  json(conn, %{
    data: Enum.map(movements, fn m ->
      %{
        id: m.id,
        item_id: m.item_id,
        quantity: m.quantity,
        movement_type: m.movement_type,
        created_at: m.inserted_at
      }
    end)
  })
end
end
