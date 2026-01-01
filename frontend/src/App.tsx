import { BrowserRouter, Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import Home from "./pages/Home";
import Items from "./pages/Items";
import CreateItem from "./pages/CreateItem";
import Movement from "./pages/Movement";
import ItemDetail from "./pages/ItemDetail";

export default function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/items" element={<Items />} />
        <Route path="/create-item" element={<CreateItem />} />
        <Route path="/movement" element={<Movement />} />
        <Route path="/items/:id" element={<ItemDetail />} /> {/* ✅ */}
      </Routes>
    </BrowserRouter>
  );
}
