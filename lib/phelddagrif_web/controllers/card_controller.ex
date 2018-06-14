defmodule PhelddagrifWeb.CardController do
  use PhelddagrifWeb, :controller

  alias Phelddagrif.Atlas

  require Logger

  action_fallback PhelddagrifWeb.FallbackController

  def index(conn, _params) do
    cards = Atlas.list_cards()
    render(conn, "index.json", cards: cards)
  end

  def show(conn, %{"id" => id}) do
    card = Atlas.get_card!(id)
    render(conn, "show.json", %{card: card})
  end
end
