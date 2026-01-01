defmodule Backend.Inventory.InventoryMovement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_movements" do
    field :quantity, :integer

    field :movement_type, Ecto.Enum,
      values: [:in, :out, :adjustment]

    belongs_to :item, Backend.Inventory.Item

    timestamps(updated_at: false)
  end

  def changeset(movement, attrs) do
  movement
  |> cast(attrs, [:item_id, :quantity, :movement_type])
  |> validate_required([:item_id, :quantity, :movement_type])
  |> validate_quantity_by_type()
  |> assoc_constraint(:item)
end

defp validate_quantity_by_type(changeset) do
  type = get_field(changeset, :movement_type)
  qty  = get_field(changeset, :quantity)

  cond do
    type in [:in, :out] ->
      validate_number(changeset, :quantity, greater_than: 0)

    type == :adjustment ->
      if qty == 0 do
        add_error(changeset, :quantity, "adjustment cannot be zero")
      else
        changeset
      end

    true ->
      changeset
  end
end

end
