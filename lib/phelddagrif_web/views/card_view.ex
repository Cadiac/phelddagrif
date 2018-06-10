defmodule PhelddagrifWeb.CardView do
  use PhelddagrifWeb, :view
  alias PhelddagrifWeb.CardView

  require Logger

  def render("index.json", %{cards: cards}) do
    render_many(cards, CardView, "card.json")
  end

  def render("show.json", %{card: card}) do
    render_one(card, CardView, "card.json")
  end

  def render("card.json", %{card: card}) do
    %{id: card.id,
      name: card.name,
      image_uris: card.image_uris,
      mana_cost: card.mana_cost,
      cmc: card.cmc,
      power: card.power,
      toughness: card.toughness,
      colors: card.colors,
      set: %{
        set_name: card.set_name,
        set_code: card.set
      }
    }
  end
end