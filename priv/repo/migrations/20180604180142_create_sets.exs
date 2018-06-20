defmodule Phelddagrif.Repo.Migrations.CreateSets do
  use Ecto.Migration

  def change do
    create table(:sets) do
      add :code, :string, [size: 40, comment: "The unique three or four-letter code for this set."]
      add :mtgo_code, :string, comment: "The unique code for this set on MTGO, which may differ from the regular code."
      add :name, :string, null: false, comment: "The English name of the set."
      add :set_type, :string, null: false, comment: "A computer-readable classification for this set. See below."
      add :released_at, :date, comment: "The date the set was released (in GMT-8 Pacific time). Not all sets have a known release date."
      add :block_code, :string, comment: "The block code for this set, if any."
      add :block, :string, comment: "The block or group name code for this set, if any."
      add :parent_set_code, :string, comment: "The set code for the parent set, if any. promo and token sets often have a parent set."
      add :card_count, :integer, null: false, comment: "The number of cards in this set."
      add :digital, :boolean, default: false, null: false, comment: "True if this set was only released on Magic Online."
      add :foil_only, :boolean, default: false, null: false, comment: "True if this set contains only foil cards."
      add :icon_svg_uri, :string, null: false, comment: "A URI to an SVG file for this set’s icon on Scryfall’s CDN. Hotlinking this image isn’t recommended, because it may change slightly over time. You should download it and use it locally for your particular user interface needs."
      add :search_uri, :string, null: false, comment: "A Scryfall API URI that you can request to begin paginating over the cards in this set."

      timestamps()
    end

    create unique_index(:sets, [:code])
  end
end
