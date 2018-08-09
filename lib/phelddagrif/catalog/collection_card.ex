defmodule Phelddagrif.Catalog.CollectionCard do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phelddagrif.Atlas.Card
  alias Phelddagrif.Catalog.Collection
  alias Phelddagrif.Catalog.CollectionCard

  schema "collection_cards" do
    timestamps()

    belongs_to :card, Card, foreign_key: :card_id
    belongs_to :collection, Collection, foreign_key: :collection_id
  end
end
