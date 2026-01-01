defmodule BackendWeb.MovementControllerTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Inventory

  setup do
    {:ok, item} =
      Inventory.create_item(%{
        "name" => "Rice",
        "sku" => "RICE-001",
        "unit" => "kg"
      })

    %{item: item}
  end

  test "POST /api/movements records inventory movement", %{conn: conn, item: item} do
    payload = %{
      "movement" => %{
        "item_id" => item.id,
        "quantity" => 10,
        "movement_type" => "in"
      }
    }

    conn = post(conn, "/api/movements", payload)

    item_id = item.id

    assert %{
      "data" => %{
        "item_id" => ^item_id,
        "quantity" => 10,
        "movement_type" => "in"
      }
    } = json_response(conn, 200)
  end

  test "GET /api/items/:item_id/movements returns movement history", %{
    conn: conn,
    item: item
  } do
    # Create movement via API (not via context)
    payload = %{
      "movement" => %{
        "item_id" => item.id,
        "quantity" => 5,
        "movement_type" => "in"
      }
    }

    post(conn, "/api/movements", payload)

    conn = get(conn, "/api/items/#{item.id}/movements")

    assert %{"data" => movements} = json_response(conn, 200)
    assert length(movements) >= 1
  end
end
