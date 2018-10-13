defmodule Phelddagrif.Repo.Migrations.AddCardImagesLink do
  use Ecto.Migration

  def change do
    create table (:card_images) do
      add :card_id, references(:cards, on_delete: :nothing), null: false
      add :last_modified, :utc_datetime, comment: "DateTime of when the image was last updated on Scryfall.", null: false
      add :illustration_id, :uuid, comment: "A unique identifier for the card artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet."
      add :url, :string, comment: "Relative url to the saved image.", null: false
      add :content_type, :string, comment: "Content-Type of the image.", null: false
      add :content_length, :integer, comment: "Content-Length of the image.", null: false
      add :primary, :boolean, comment: "Is this the primary or secondary image (like a flip-side image of a double sided card etc)", null: false

      timestamps()
    end

    create index(:card_images, [:card_id])
    create unique_index(:card_images, [:card_id, :primary])
  end
end
