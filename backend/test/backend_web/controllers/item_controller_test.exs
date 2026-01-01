defmodule BackendWeb.ItemControllerTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Inventory

  @create_item_attrs %{
    "name" => "Sugar",
    "sku" => "SUG-001",
    "unit" => "kg"
  }

  test "POST /api/items creates an item", %{conn: conn} do
    conn = post(conn, "/api/items", %{"item" => @create_item_attrs})

    assert %{
      "data" => %{
        "id" => id,
        "name" => "Sugar",
        "sku" => "SUG-001",
        "unit" => "kg",
        "current_stock" => 0
      }
    } = json_response(conn, 200)

    assert is_integer(id)
  end

  test "GET /api/items returns list of items", %{conn: conn} do
    {:ok, _item} = Inventory.create_item(@create_item_attrs)

    conn = get(conn, "/api/items")

    assert %{"data" => items} = json_response(conn, 200)
    assert length(items) >= 1
  end
end
