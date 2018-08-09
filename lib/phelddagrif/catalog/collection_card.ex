defmodule Phelddagrif.Catalog.CollectionCard do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phelddagrif.Atlas.Card
  alias Phelddagrif.Catalog.Collection
  alias Phelddagrif.Catalog.CollectionCard

  schema "collection_cards" do
    timestamps()

    field :quantity, :integer

    belongs_to :card, Card, foreign_key: :card_id
    belongs_to :collection, Collection, foreign_key: :collection_id
  end

  @doc false
  def changeset(collection_card, attrs) do
    collection_card
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
  end
end
