const API_BASE = "http://localhost:4000/api";

export async function fetchItems() {
  const res = await fetch(`${API_BASE}/items`);
  if (!res.ok) throw new Error("Failed to fetch items");
  const json = await res.json();
  return json.data;
}

export async function createItem(payload: {
  name: string;
  sku: string;
  unit: string;
}) {
  const res = await fetch(`${API_BASE}/items`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    // 🔑 backend expects { item: {...} }
    body: JSON.stringify({ item: payload }),
  });

  if (!res.ok) {
    const data = await res.json();
    throw new Error(JSON.stringify(data.errors));
  }

  return res.json();
}

// ✅ Add this function to fix your error
export async function recordMovement(payload: {
  item_id: number;
  quantity: number;
  movement_type: string;
}) {
  const res = await fetch(`${API_BASE}/movements`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ movement: payload }),
  });

  if (!res.ok) {
    const data = await res.json();
    throw new Error(data.error || "Failed to record movement");
  }

  return res.json();
}

export async function fetchItemMovements(itemId: number) {
  const res = await fetch(`${API_BASE}/items/${itemId}/movements`);
  if (!res.ok) throw new Error("Failed to fetch movements");
  const json = await res.json();
  return json.data;
}
