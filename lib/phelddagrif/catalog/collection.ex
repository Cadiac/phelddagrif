defmodule Phelddagrif.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phelddagrif.Atlas.Card
  alias Phelddagrif.Catalog.CollectionCard

  schema "collections" do
    field :name, :string
    field :owner, :string

    # many_to_many :cards, Card, join_through: Phelddagrif.Catalog.CollectionCard

    has_many :collection_cards, CollectionCard, on_delete: :delete_all
    has_many :cards, through: [:collection_cards, :card]

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :owner])
    |> validate_required([:name, :owner])
  end
end
