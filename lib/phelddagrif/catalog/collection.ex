defmodule Phelddagrif.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phelddagrif.Atlas.Card

  schema "collections" do
    field :name, :string
    field :owner, :string

    many_to_many :cards, Card, join_through: Phelddagrif.Catalog.CollectionCard

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :owner])
    |> cast_assoc(:cards, required: false)
    |> validate_required([:name, :owner])
  end
end
