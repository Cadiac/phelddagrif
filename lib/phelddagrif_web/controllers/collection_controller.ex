defmodule PhelddagrifWeb.CollectionController do
  use PhelddagrifWeb, :controller

  alias Phelddagrif.Catalog
  alias Phelddagrif.Catalog.Collection

  action_fallback PhelddagrifWeb.FallbackController

  def index(conn, _params) do
    collections = Catalog.list_collections()
    render(conn, "index.json", collections: collections)
  end

  def create(conn, %{"collection" => collection_params}) do
    with {:ok, %Collection{} = collection} <- Catalog.create_collection(collection_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", collection_path(conn, :show, collection))
      |> render("show.json", collection: collection)
    end
  end

  def show(conn, %{"id" => id}) do
    collection = Catalog.get_collection!(id)
    render(conn, "show.json", collection: collection)
  end

  def update(conn, %{"id" => id, "collection" => collection_params}) do
    collection = Catalog.get_collection!(id)

    with {:ok, %Collection{} = collection} <- Catalog.update_collection(collection, collection_params) do
      render(conn, "show.json", collection: collection)
    end
  end

  def delete(conn, %{"id" => id}) do
    collection = Catalog.get_collection!(id)
    with {:ok, %Collection{}} <- Catalog.delete_collection(collection) do
      send_resp(conn, :no_content, "")
    end
  end
end
