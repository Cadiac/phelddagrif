defmodule Phelddagrif.Catalog.CollectionCard do
  use Ecto.Schema
  import Ecto.Changeset


  schema "collection_cards" do
    field :quantity, :integer
    field :card_id, :id
    field :collection_id, :id

    timestamps()
  end

  @doc false
  def changeset(collection_card, attrs) do
    collection_card
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
