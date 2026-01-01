import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import { fetchItems, fetchItemMovements } from "../api/client";

export default function ItemDetail() {
  const { id } = useParams();
  const itemId = Number(id);

  const [item, setItem] = useState<any>(null);
  const [movements, setMovements] = useState<any[]>([]);

  useEffect(() => {
    if (!itemId) return;

    // 1️⃣ Get item basic info from items list
    fetchItems().then((items) => {
      const found = items.find((i: any) => i.id === itemId);
      setItem(found);
    });

    // 2️⃣ Get movement history
    fetchItemMovements(itemId).then(setMovements);
  }, [itemId]);

  if (!item) return <p className="p-6">Loading...</p>;

  return (
    <div className="container">
      <div className="card">
        <h2 className="text-2xl font-bold mb-2">{item.name}</h2>
        <p>SKU: {item.sku}</p>
        <p>Unit: {item.unit}</p>
        <p className="font-semibold mt-2">
          Current Stock: {item.current_stock}
        </p>

        <h3 className="mt-4 font-bold">Movement History</h3>

        {movements.length === 0 ? (
          <p className="text-sm text-gray-500 mt-2">No movements yet</p>
        ) : (
          <ul className="mt-2 space-y-1">
            {movements.map((m) => (
              <li key={m.id}>
                {m.movement_type} — {m.quantity}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}
