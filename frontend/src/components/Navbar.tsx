import { Link } from "react-router-dom";

export default function Navbar() {
  return (
    <div className="navbar">
      <Link to="/">🥗 The Salad House</Link>
      <Link to="/items">Items</Link>
      <Link to="/create-item">Create Item</Link>
      <Link to="/movement">Inventory Movement</Link>
    </div>
  );
}
