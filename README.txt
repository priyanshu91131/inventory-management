Inventory Management System

A simple inventory management system to track stock movements, including incoming stock, outgoing stock, and manual adjustments. Built with Elixir/Phoenix for the backend and React for the frontend.

🗂️ Data Model
Item

Represents products in the inventory.

Field	Type	Description
id	integer	Primary key
name	string	Name of the item
stock	integer	Current stock count
inserted_at	datetime	Created timestamp
updated_at	datetime	Last updated timestamp
InventoryMovement

Represents movements in inventory: stock in, stock out, or adjustments.

Field	Type	Description
id	integer	Primary key
item_id	integer	Foreign key to Item
movement_type	enum	:in, :out, :adjustment
quantity	integer	Positive for in and out, positive or negative for adjustment
inserted_at	datetime	Timestamp of the movement

Relationships:

InventoryMovement belongs to Item.

Item has many InventoryMovements.

📊 Stock Calculation Logic

Current stock is derived from the sum of all movements:

stock = Enum.reduce(movements, 0, fn movement, acc ->
  case movement.movement_type do
    :in -> acc + movement.quantity
    :out -> acc - movement.quantity
    :adjustment -> acc + movement.quantity
  end
end)


Rules:

:in — increases stock (quantity must be > 0).

:out — decreases stock (quantity must be > 0).

:adjustment — can be positive or negative, but cannot be 0.

Stock cannot go below 0 for :out and resulting stock after adjustment must also be non-negative.

🚀 How to Run the Project
Backend (Elixir / Phoenix)

Install dependencies:

mix deps.get


Setup database:

mix ecto.setup


Run the server:

mix phx.server


API will be available at:

http://localhost:4000/api


Key Endpoints:

GET /api/items — list all items

POST /api/movements — record a stock movement

Frontend (React)

Install dependencies:

npm install


Run the development server:

npm start


Open your browser:

http://localhost:3000


Features:

Record stock in, out, or adjustment

View current stock per item

Validates quantity rules depending on movement type

⚡ Assumptions

Items always exist in the database before movements.

Stock cannot go below 0 except if manual adjustment is negative (but cannot reduce below 0).

adjustment can be positive or negative, but not zero.

Movements are atomic — either fully applied or rejected.

Frontend input is validated, but backend rules are authoritative.

🔧 Potential Improvements

Add user authentication and roles (admin, staff).

Implement stock history view per item.

Add batch movement import via CSV.

Handle concurrent stock updates with database transactions.

Improve frontend UX with better error handling and live stock updates.

Add unit and integration tests for movement logic.