import { useEffect, useState } from "react";
import { fetchItems, recordMovement } from "../api/client";

export default function Movement() {
  const [items, setItems] = useState<any[]>([]);
  const [itemId, setItemId] = useState<number | null>(null);
  const [quantity, setQuantity] = useState<string>(""); // start empty
  const [type, setType] = useState("in");
  const [success, setSuccess] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    fetchItems()
      .then((data) => setItems(data))
      .catch((err) => console.error(err));
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSuccess("");
    setError("");

    if (!itemId) return setError("Please select an item");

    const qty = Number(quantity);

    if (type === "adjustment") {
      if (quantity === "" || isNaN(qty) || qty === 0) {
        return setError("Please enter a non-zero quantity for adjustments");
      }
    } else {
      if (!quantity || isNaN(qty) || qty < 1) {
        return setError("Please enter a quantity of 1 or greater");
      }
    }

    try {
      await recordMovement({ item_id: itemId, quantity: qty, movement_type: type });
      setSuccess("Movement recorded successfully!");
      setQuantity("");
      setType("in");
      setItemId(null);
    } catch (err: any) {
      setError(err.message || String(err));
    }
  };

  return (
    <div className="container">
      <div className="card">
        <h2 className="text-2xl font-bold mb-4">Record Inventory Movement</h2>
        {success && <p className="text-green-600 mb-2">{success}</p>}
        {error && <p className="text-red-600 mb-2">{error}</p>}
        <form onSubmit={handleSubmit}>
          <label>Item</label>
          <select
            value={itemId ?? ""}
            onChange={(e) => setItemId(e.target.value ? Number(e.target.value) : null)}
            required
          >
            <option value="" disabled>Select item</option>
            {items.map((item) => (
              <option key={item.id} value={item.id}>
                {item.name}
                {(item.stock ?? 0) > 0 ? ` (Stock: ${item.stock})` : ""}
              </option>
            ))}
          </select>

          <label>Movement Type</label>
          <select
            value={type}
            onChange={(e) => {
              setType(e.target.value);
              setQuantity(""); // reset quantity when type changes
            }}
          >
            <option value="in">In</option>
            <option value="out">Out</option>
            <option value="adjustment">Adjustment</option>
          </select>

          <label>Quantity</label>
          <input
            type="text"
            inputMode="numeric"
            value={quantity}
            onChange={(e) => {
              const raw = e.target.value;
              if (type === "adjustment") {
                // allow optional leading '-' and digits, strip leading zeros after sign
                const match = raw.match(/^-?\d*/);
                const cleaned = (match ? match[0] : "").replace(/^(-?)0+(?=\d)/, "$1");
                setQuantity(cleaned);
              } else {
                // positive only: digits only, strip leading zeros
                const digits = raw.replace(/\D/g, "");
                const normalized = digits.replace(/^0+/, "");
                setQuantity(normalized);
              }
            }}
            placeholder={type === "adjustment" ? "e.g. -5 or 5" : "1"}
            required
          />

          <button type="submit">Record Movement</button>
        </form>
      </div>
    </div>
  );
}
