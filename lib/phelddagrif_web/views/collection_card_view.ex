defmodule PhelddagrifWeb.CollectionCardView do
  use PhelddagrifWeb, :view
  alias PhelddagrifWeb.CollectionCardView
  alias PhelddagrifWeb.CardView

  def render("index.json", %{collection_cards: collection_cards}) do
    %{data: render_many(collection_cards, CollectionCardView, "collection_card.json")}
  end

  def render("show.json", %{collection_card: collection_card}) do
    render_one(collection_card, CollectionCardView, "collection_card.json")
  end

  def render("collection_card.json", %{collection_card: collection_card}) do
    %{card: render_one(collection_card.card, CardView, "card.json"),
      quantity: collection_card.quantity
    }
  end
end
