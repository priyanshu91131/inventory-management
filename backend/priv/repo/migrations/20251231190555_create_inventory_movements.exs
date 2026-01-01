defmodule Backend.Repo.Migrations.CreateInventoryMovements do
  use Ecto.Migration

  def change do
    create table(:inventory_movements) do
      add :item_id, references(:items, on_delete: :restrict), null: false
      add :quantity, :integer, null: false
      add :movement_type, :string, null: false

      timestamps(updated_at: false)
    end

    create index(:inventory_movements, [:item_id])
  end
end
