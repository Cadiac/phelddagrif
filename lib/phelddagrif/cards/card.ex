defmodule Phelddagrif.Cards.Card do
    use Ecto.Schema
    import Ecto.Changeset

    alias Phelddagrif.Cards.Card

    schema "cards" do
      field :card_id, :binary_id, null: false
      field :oracle_id, :binary_id, null: false
      field :multiverse_ids, {:array, :map}, default: []

      field :mtgo_id, :integer
      field :mtgo_foil_id, :integer
      field :arena_id, :integer

      field :uri, :string, null: false
      field :scryfall_uri, :string, null: false
      field :prints_search_uri, :string, null: false
      field :rulings_uri, :string, null: false

      # Gameplay fields
      field :name, :string, null: false
      field :layout, :integer, null: false

      field :cmc, :decimal, null: false
      field :type_line, :string, null: false
      field :oracle_text, :string

      field :mana_cost, :string, null: false
      field :power, :string
      field :toughness, :string
      field :loyalty, :string
      field :life_modifier, :string
      field :hand_modifier, :string

      field :colors, {:array, :map}, default: [], null: false
      field :color_indicator, {:array, :map}, default: []
      field :color_identity, {:array, :map}, default: [], null: false

      field :all_parts, {:array, :map}, default: []
      field :card_faces, {:array, :map}, default: []
      field :legalities, :map, null: false

      field :reserved, :boolean, null: false
      field :foil, :boolean, null: false
      field :nonfoil, :boolean, null: false
      field :oversized, :boolean, null: false
      field :edhrec_rank, :integer

      # Print fields

      field :set, :string, null: false
      field :set_name, :string, null: false
      field :collector_number, :string, null: false
      field :set_search_uri, :string, null: false
      field :scryfall_set_uri, :string, null: false
      field :image_uris, :map
      field :highres_image, :boolean
      field :printed_name, :string, null: false
      field :printed_type_line, :string, null: false
      field :printed_text, :string, null: false
      field :reprint, :boolean, null: false
      field :digital, :boolean, null: false
      field :rarity, :string, null: false
      field :flavor_text, :string
      field :artist, :string
      field :illustration_id, :binary_id

      field :frame, :string, null: false
      field :full_art, :boolean, null: false
      field :watermark, :string
      field :border_color, :string, null: false
      field :story_spotlight_number, :integer
      field :story_spotlight_uri, :string
      field :timeshifted, :boolean, null: false
      field :colorshifted, :boolean, null: false
      field :futureshifted, :boolean, null: false

      timestamps()
    end

    @doc false
    def changeset(%Card{} = card, attrs) do
      card
    end
  end


