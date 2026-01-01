defmodule Backend.Inventory do
  import Ecto.Query
  alias Backend.Repo
  alias Backend.Inventory.{Item, InventoryMovement}

  # --- ITEMS ---
  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def list_items_with_stock do
  Repo.all(Item)
  |> Enum.map(fn item ->
    stock = get_stock(item.id)

    %{
      id: item.id,
      name: item.name,
      sku: item.sku,
      unit: item.unit,
      current_stock: stock
    }
  end)
end


  # --- MOVEMENTS ---
  def record_movement(attrs) do
    Repo.transaction(fn ->
      case Repo.insert(InventoryMovement.changeset(%InventoryMovement{}, attrs)) do
        {:ok, movement} ->
          stock = get_stock(movement.item_id)

          if stock < 0 do
            Repo.rollback("negative stock")
          else
            movement
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
    |> case do
      {:ok, movement} -> {:ok, movement}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
      {:error, reason} when is_binary(reason) -> {:error, reason}
    end
  end

  def movement_history(item_id) do
    Repo.all(
      from m in InventoryMovement,
        where: m.item_id == ^item_id,
        order_by: [desc: m.inserted_at]
    )
  end

  # --- STOCK CALCULATION ---
  def get_stock(item_id) do
    query = from m in InventoryMovement,
            where: m.item_id == ^item_id,
            select: {m.movement_type, m.quantity}

    Repo.all(query)
    |> Enum.reduce(0, fn
      {:in, q}, acc -> acc + q
      {:out, q}, acc -> acc - q
      {:adjustment, q}, acc -> acc + q
    end)
  end

  def list_movements_for_item(item_id) do
  InventoryMovement
  |> where([m], m.item_id == ^item_id)
  |> order_by([m], desc: m.inserted_at)
  |> Repo.all()
  end
end
