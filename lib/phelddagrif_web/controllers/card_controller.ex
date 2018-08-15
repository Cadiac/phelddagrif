defmodule PhelddagrifWeb.CardController do
  use PhelddagrifWeb, :controller

  alias Phelddagrif.Atlas

  require Logger

  action_fallback PhelddagrifWeb.FallbackController

  def index(conn, params) do
    page = params |> Map.get("page", "1") |> String.to_integer
    limit = params |> Map.get("limit", "100") |> String.to_integer

    result = Atlas.list_cards(page, limit)
    render(conn, "index.json", result)
  end

  def show(conn, %{"id" => id}) do
    card = Atlas.get_card!(id)
    render(conn, "show.json", %{card: card})
  end
end
