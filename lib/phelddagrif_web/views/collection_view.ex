defmodule PhelddagrifWeb.CollectionView do
  use PhelddagrifWeb, :view
  alias PhelddagrifWeb.CollectionView

  def render("index.json", %{collections: collections}) do
    %{data: render_many(collections, CollectionView, "collection.json")}
  end

  def render("show.json", %{collection: collection}) do
    render_one(collection, CollectionView, "collection.json")
  end

  def render("collection.json", %{collection: collection}) do
    %{id: collection.id,
      name: collection.name,
      owner: collection.owner,
      total_cards: Map.get(collection, :total_cards),
      unique_cards: Map.get(collection, :unique_cards)
    }
  end
end
