defmodule Phelddagrif.Repo.Migrations.AddCardsTable do
  use Ecto.Migration

  # Schema borrowed from https://scryfall.com/docs/api/cards

  def change do
    create table("cards") do
      # Core fields
      add :scryfall_id, :uuid, null: false, comment: "A unique ID for this card in Scryfall’s database."
      add :oracle_id, :uuid, null: false, comment: "A unique ID for this card’s oracle identity. This value is consistent across reprinted card editions, and unique among different cards with the same name (tokens, Unstable variants, etc)."
      add :multiverse_ids, {:array, :integer}, default: [], comment: "This card’s multiverse IDs on Gatherer, if any, as an array of integers. Note that Scryfall includes many promo cards, tokens, and other esoteric objects that do not have these identifiers."

      add :mtgo_id, :integer, comment: "This card’s Magic Online ID (also known as the Catalog ID), if any. A large percentage of cards are not available on Magic Online and do not have this ID."
      add :mtgo_foil_id, :integer, comment: "This card’s foil Magic Online ID (also known as the Catalog ID), if any. A large percentage of cards are not available on Magic Online and do not have this ID."
      add :arena_id, :integer, comment: "This card’s Arena ID, if any. A large percentage of cards are not available on Arena and do not have this ID."

      add :uri, :text, null: false, comment: "A link to this card object on Scryfall’s API."
      add :scryfall_uri, :text, null: false, comment: "A link to this card’s permapage on Scryfall’s website."
      add :prints_search_uri, :text, null: false, comment: "A link to where you can begin paginating all re/prints for this card on Scryfall’s API."
      add :rulings_uri, :text, null: false, comment: "A link to this card’s rulings on Scryfall’s API."

      # Gameplay fields
      add :name, :text, null: false, comment: "The name of this card. If this card has multiple faces, this field will contain both names separated by ..//.."
      add :layout, :text, null: false, comment: "A computer-readable designation for this card’s layout. See the layout article."

      add :cmc, :decimal, null: false, comment: "The card’s converted mana cost. Note that some funny cards have fractional mana costs."
      add :type_line, :text, null: false, comment: "The type line of this card."
      add :oracle_text, :text, comment: "The Oracle text for this card, if any."

      add :mana_cost, :text, null: false, comment: "The mana cost for this card. This value will be any empty string if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values."
      add :power, :text, comment: "This card’s power, if any. Note that some cards have powers that are not numeric, such as *."
      add :toughness, :text, comment: "This card’s toughness, if any. Note that some cards have toughnesses that are not numeric, such as *."
      add :loyalty, :text, comment: "This loyalty if any. Note that some cards have loyalties that are not numeric, such as X."
      add :life_modifier, :text, comment: "This card’s life modifier, if it is Vanguard card. This value will contain a delta, such as +2."
      add :hand_modifier, :text, comment: "This card’s hand modifier, if it is Vanguard card. This value will contain a delta, such as -1."

      add :colors, {:array, :text}, default: [], null: false, comment: "This card’s colors."
      add :color_indicator, {:array, :text}, default: [], comment: "The colors in this card’s color indicator, if any. A null value for this field indicates the card does not have one."
      add :color_identity, {:array, :text}, default: [], null: false, comment: "This card’s color identity."

      add :all_parts, {:array, :map}, default: [], comment: "If this card is closely related to other cards, this property will be an array with."
      add :card_faces, {:array, :map}, default: [], comment: "An array of Card Face objects, if this card is multifaced."
      add :legalities, :map, null: false, comment: "An object describing the legality of this card."

      add :reserved, :boolean, null: false, comment: "True if this card is on the Reserved List."
      add :foil, :boolean, null: false, comment: "True if this printing exists in a foil version."
      add :nonfoil, :boolean, null: false, comment: "True if this printing exists in a nonfoil version."
      add :oversized, :boolean, null: false, comment: "True if this card is oversized."
      add :edhrec_rank, :integer, comment: "This card’s overall rank/popularity on EDHREC. Not all carsd are ranked."

      # Print fields

      add :set, :text, null: false, comment: "This card’s set code."
      add :set_name, :text, null: false, comment: "This card’s full set name."
      add :collector_number, :text, null: false, comment: "This card’s collector number. Note that collector numbers can contain non-numeric characters, such as letters or *"
      add :set_search_uri, :text, null: false, comment: "A link to where you can begin paginating this card’s set on the Scryfall API."
      add :scryfall_set_uri, :text, null: false, comment: "A link to this card’s set on Scryfall’s website."
      add :image_uris, :map, comment: "An object listing available imagery for this card. See the [Card Imagery](#) article for more information."
      add :highres_image, :boolean, comment: "True if this card’s imagery is high resolution."
      add :printed_name, :text, null: false, comment: "The localized name printed on this card, if any."
      add :printed_type_line, :text, null: false, comment: "The localized type line printed on this card, if any."
      add :printed_text, :text, null: false, comment: "The localized text printed on this card, if any."
      add :reprint, :boolean, null: false, comment: "True if this card is a reprint."
      add :digital, :boolean, null: false, comment: "True if this is a digital card on Magic Online."
      add :rarity, :text, null: false, comment: "This card’s rarity. One of common, uncommon, rare, or mythic."
      add :flavor_text, :text, comment: "The flavor text, if any."
      add :artist, :text, comment: "The name of the illustrator of this card. Newly spoiled cards may not have this field yet."
      add :illustration_id, :uuid, comment: "A unique identifier for the card artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet."

      add :frame, :text, null: false, comment: "This card’s frame layout."
      add :full_art, :boolean, null: false, comment: "True if this card’s artwork is larger than normal."
      add :watermark, :text, comment: "This card’s watermark, if any."
      add :border_color, :text, null: false, comment: "This card’s border color: black, borderless, gold, silver, or white."
      add :story_spotlight_number, :integer, comment: "This card’s story spotlight number, if any."
      add :story_spotlight_uri, :text, comment: "A URL to this cards’s story article, if any."
      add :timeshifted, :boolean, null: false, comment: "True if this card is timeshifted."
      add :colorshifted, :boolean, null: false, comment: "True if this card is colorshifted."
      add :futureshifted, :boolean, null: false, comment: "True if this card is from the future."

      timestamps()
    end
  end
end
