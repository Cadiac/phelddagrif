defmodule PhelddagrifWeb.CollectionCardControllerTest do
  use PhelddagrifWeb.ConnCase

  alias Phelddagrif.Catalog
  alias Phelddagrif.Catalog.CollectionCard

  @create_attrs %{quantity: 42}
  @update_attrs %{quantity: 43}
  @invalid_attrs %{quantity: nil}

  def fixture(:collection_card) do
    {:ok, collection_card} = Catalog.create_collection_card(@create_attrs)
    collection_card
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all collection_cards", %{conn: conn} do
      conn = get conn, collection_card_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create collection_card" do
    test "renders collection_card when data is valid", %{conn: conn} do
      conn = post conn, collection_card_path(conn, :create), collection_card: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, collection_card_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "quantity" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, collection_card_path(conn, :create), collection_card: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update collection_card" do
    setup [:create_collection_card]

    test "renders collection_card when data is valid", %{conn: conn, collection_card: %CollectionCard{id: id} = collection_card} do
      conn = put conn, collection_card_path(conn, :update, collection_card), collection_card: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, collection_card_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "quantity" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, collection_card: collection_card} do
      conn = put conn, collection_card_path(conn, :update, collection_card), collection_card: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete collection_card" do
    setup [:create_collection_card]

    test "deletes chosen collection_card", %{conn: conn, collection_card: collection_card} do
      conn = delete conn, collection_card_path(conn, :delete, collection_card)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, collection_card_path(conn, :show, collection_card)
      end
    end
  end

  defp create_collection_card(_) do
    collection_card = fixture(:collection_card)
    {:ok, collection_card: collection_card}
  end
end
