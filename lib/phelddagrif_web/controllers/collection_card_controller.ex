defmodule PhelddagrifWeb.CollectionCardController do
  use PhelddagrifWeb, :controller

  alias Phelddagrif.Catalog
  alias Phelddagrif.Catalog.CollectionCard

  action_fallback PhelddagrifWeb.FallbackController

  def index(conn, _params) do
    collection_cards = Catalog.list_collection_cards()
    render(conn, "index.json", collection_cards: collection_cards)
  end

  def create(conn, %{"collection_card" => collection_card_params}) do
    with {:ok, _} <- Catalog.add_card_to_collection(collection_card_params) do
      conn
      |> send_resp(201, "")
      # |> put_status(:created)
      # |> render("show.json", collection_card: collection_card)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   collection_card = Catalog.get_collection_card!(id)
  #   render(conn, "show.json", collection_card: collection_card)
  # end

  # def update(conn, %{"id" => id, "collection_card" => collection_card_params}) do
  #   collection_card = Catalog.get_collection_card!(id)

  #   with {:ok, %CollectionCard{} = collection_card} <- Catalog.update_collection_card(collection_card, collection_card_params) do
  #     render(conn, "show.json", collection_card: collection_card)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   collection_card = Catalog.get_collection_card!(id)
  #   with {:ok, %CollectionCard{}} <- Catalog.delete_collection_card(collection_card) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
