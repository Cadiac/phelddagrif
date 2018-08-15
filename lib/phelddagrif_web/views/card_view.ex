defmodule PhelddagrifWeb.CardView do
  use PhelddagrifWeb, :view
  alias PhelddagrifWeb.CardView

  require Logger

  def render("index.json", %{total_count: total_count, has_more: has_more, cards: cards}) do
    %{
      total_count: total_count,
      has_more: has_more,
      data: render_many(cards, CardView, "card.json")
    }
  end

  def render("show.json", %{card: card}) do
    render_one(card, CardView, "card.json")
  end

  def render("card.json", %{card: card}) do
    %{
      id: card.id,
      name: card.name,
      image_uris: card.image_uris,
      mana_cost: card.mana_cost,
      cmc: card.cmc,
      power: card.power,
      toughness: card.toughness,
      colors: card.colors,
      set: render_one(card.set, PhelddagrifWeb.SetView, "set.json")
    }
  end
end
