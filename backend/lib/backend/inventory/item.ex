defmodule Backend.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :sku, :string
    field :unit, Ecto.Enum, values: [:pcs, :kg, :litre]

    has_many :inventory_movements, Backend.Inventory.InventoryMovement

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :sku, :unit])
    |> validate_required([:name, :sku, :unit])
    |> unique_constraint(:sku)
  end
end
