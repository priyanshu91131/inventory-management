defmodule Backend.InventoryTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Inventory
  alias Backend.Repo
  alias Backend.Inventory.InventoryMovement

  describe "stock calculation" do
    test "calculates stock from inventory movements" do
      {:ok, item} =
        Inventory.create_item(%{
          "name" => "Sugar",
          "sku" => "SUG-001",
          "unit" => "kg"
        })

      # Direct Repo inserts → MUST use atoms for enums
      Repo.insert!(%InventoryMovement{
        item_id: item.id,
        quantity: 10,
        movement_type: :in
      })

      Repo.insert!(%InventoryMovement{
        item_id: item.id,
        quantity: 3,
        movement_type: :out
      })

      Repo.insert!(%InventoryMovement{
        item_id: item.id,
        quantity: 2,
        movement_type: :adjustment
      })

      [item_with_stock] = Inventory.list_items_with_stock()

      assert item_with_stock.current_stock == 9
    end
  end

  describe "negative stock protection" do
  test "rejects inventory movement that causes negative stock", %{conn: conn} do
    {:ok, item} =
      Inventory.create_item(%{
        "name" => "Flour",
        "sku" => "FLR-001",
        "unit" => "kg"
      })

    payload = %{
      "movement" => %{
        "item_id" => item.id,
        "quantity" => 5,
        "movement_type" => "out"
      }
    }

    conn = post(conn, "/api/movements", payload)

    assert json_response(conn, 422)["error"] =~ "negative stock"
  end
end

end
