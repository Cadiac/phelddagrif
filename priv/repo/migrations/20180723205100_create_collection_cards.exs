defmodule Phelddagrif.Repo.Migrations.CreateCollectionCards do
  use Ecto.Migration

  def change do
    create table(:collection_cards) do
      add :card_id, references(:cards, on_delete: :nothing), null: false
      add :collection_id, references(:collections, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:collection_cards, [:card_id])
    create index(:collection_cards, [:collection_id])
    create unique_index(:collection_cards, [:collection_id, :card_id])
  end
end
