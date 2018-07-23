defmodule PhelddagrifWeb.CollectionCardView do
  use PhelddagrifWeb, :view
  alias PhelddagrifWeb.CollectionCardView

  def render("index.json", %{collection_cards: collection_cards}) do
    %{data: render_many(collection_cards, CollectionCardView, "collection_card.json")}
  end

  def render("show.json", %{collection_card: collection_card}) do
    %{data: render_one(collection_card, CollectionCardView, "collection_card.json")}
  end

  def render("collection_card.json", %{collection_card: collection_card}) do
    %{id: collection_card.id,
      quantity: collection_card.quantity}
  end
end
