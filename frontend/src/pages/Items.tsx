import { useEffect, useState } from "react";
import { fetchItems } from "../api/client";
import { useNavigate } from "react-router-dom";

export default function Items() {
  const [items, setItems] = useState<any[]>([]);
  const navigate = useNavigate();

  useEffect(() => {
    fetchItems().then(setItems);
  }, []);

  return (
    <div className="container">
      <h2 className="text-2xl font-bold mb-4">Inventory Items</h2>

      <ul className="space-y-2">
        {items.map((item) => (
          <li
            key={item.id}
            onClick={() => navigate(`/items/${item.id}`)}
            className="card cursor-pointer hover:bg-gray-100 transition"
          >
            <div className="font-semibold">{item.name}</div>
            <div className="text-sm text-gray-600">
              SKU: {item.sku} • Stock: {item.current_stock}
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}
