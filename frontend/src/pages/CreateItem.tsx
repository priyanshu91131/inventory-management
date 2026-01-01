import { useState } from "react";
import { createItem } from "../api/client";

export default function CreateItem() {
  const [name, setName] = useState("");
  const [sku, setSku] = useState("");
  const [unit, setUnit] = useState("pcs"); // default value
  const [success, setSuccess] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSuccess("");
    setError("");

    try {
      await createItem({ name, sku, unit });
      setSuccess("Item created successfully!");
      setName("");
      setSku("");
      setUnit("pcs"); // reset to default
    } catch (err: any) {
      setError(err.message);
    }
  };

  return (
    <div className="container">
      <div className="card">
        <h2 className="text-2xl font-bold mb-4">Create New Item</h2>
        {success && <p className="text-green-600 mb-2">{success}</p>}
        {error && <p className="text-red-600 mb-2">{error}</p>}

        <form onSubmit={handleSubmit}>
          <label>Name</label>
          <input value={name} onChange={(e) => setName(e.target.value)} required />

          <label>SKU</label>
          <input value={sku} onChange={(e) => setSku(e.target.value)} required />

          <label>Unit</label>
          <select value={unit} onChange={(e) => setUnit(e.target.value)} required>
            <option value="pcs">pcs</option>
            <option value="kg">kg</option>
            <option value="litre">litre</option>
          </select>

          <button type="submit">Create Item</button>
        </form>
      </div>
    </div>
  );
}
