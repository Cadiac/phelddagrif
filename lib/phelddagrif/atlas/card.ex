defmodule Phelddagrif.Atlas.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phelddagrif.Atlas.Card
  alias Phelddagrif.Atlas.CardImage
  alias Phelddagrif.Atlas.Set
  alias Phelddagrif.Catalog.Collection

  schema "cards" do
    field(:scryfall_id, :binary_id, null: false)
    field(:oracle_id, :binary_id, null: false)
    field(:multiverse_ids, {:array, :integer}, default: [])

    field(:mtgo_id, :integer)
    field(:mtgo_foil_id, :integer)
    field(:arena_id, :integer)

    field(:uri, :string, null: false)
    field(:scryfall_uri, :string, null: false)
    field(:prints_search_uri, :string, null: false)
    field(:rulings_uri, :string, null: false)

    # Gameplay fields
    field(:name, :string, null: false)
    field(:layout, :string, null: false)

    field(:cmc, :decimal, null: false)
    field(:type_line, :string, null: false)
    field(:oracle_text, :string)

    field(:mana_cost, :string, null: false, default: "")
    field(:power, :string)
    field(:toughness, :string)
    field(:loyalty, :string)
    field(:life_modifier, :string)
    field(:hand_modifier, :string)

    field(:colors, {:array, :string}, default: [], null: false)
    field(:color_indicator, {:array, :string}, default: [])
    field(:color_identity, {:array, :string}, default: [], null: false)

    field(:all_parts, {:array, :map}, default: [])
    field(:card_faces, {:array, :map}, default: [])
    field(:legalities, :map, null: false)

    field(:reserved, :boolean, null: false)
    field(:foil, :boolean, null: false)
    field(:nonfoil, :boolean, null: false)
    field(:oversized, :boolean, null: false)
    field(:edhrec_rank, :integer)

    # Print fields

    field(:collector_number, :string, null: false)
    field(:image_uris, :map)
    field(:highres_image, :boolean)
    field(:printed_name, :string, null: false, default: "")
    field(:printed_type_line, :string, null: false, default: "")
    field(:printed_text, :string, null: false, default: "")
    field(:reprint, :boolean, null: false)
    field(:digital, :boolean, null: false)
    field(:rarity, :string, null: false)
    field(:flavor_text, :string)
    field(:artist, :string)
    field(:illustration_id, :binary_id)

    field(:frame, :string, null: false)
    field(:full_art, :boolean, null: false)
    field(:watermark, :string)
    field(:border_color, :string, null: false)
    field(:story_spotlight_number, :integer)
    field(:story_spotlight_uri, :string)

    belongs_to :set, Set, foreign_key: :set_id
    many_to_many :collections, Collection, join_through: Phelddagrif.Catalog.CollectionCard

    has_many :card_images, CardImage, foreign_key: :card_id

    timestamps()
  end

  @doc false
  def changeset(%Card{} = card, attrs) do
    card
    |> cast(attrs, [
      :scryfall_id,
      :oracle_id,
      :multiverse_ids,
      :mtgo_id,
      :mtgo_foil_id,
      :arena_id,
      :uri,
      :scryfall_uri,
      :prints_search_uri,
      :rulings_uri,
      :name,
      :layout,
      :cmc,
      :type_line,
      :oracle_text,
      :mana_cost,
      :power,
      :toughness,
      :loyalty,
      :life_modifier,
      :hand_modifier,
      :colors,
      :color_indicator,
      :color_identity,
      :all_parts,
      :card_faces,
      :legalities,
      :reserved,
      :foil,
      :nonfoil,
      :oversized,
      :edhrec_rank,
      :collector_number,
      :image_uris,
      :highres_image,
      :printed_name,
      :printed_type_line,
      :printed_text,
      :reprint,
      :digital,
      :rarity,
      :flavor_text,
      :artist,
      :illustration_id,
      :frame,
      :full_art,
      :watermark,
      :border_color,
      :story_spotlight_number,
      :story_spotlight_uri,
    ])
    |> cast_assoc(:collections, required: false)
  end
end
