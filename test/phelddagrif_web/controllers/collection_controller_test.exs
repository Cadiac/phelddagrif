defmodule PhelddagrifWeb.CollectionControllerTest do
  use PhelddagrifWeb.ConnCase

  alias Phelddagrif.Catalog
  alias Phelddagrif.Catalog.Collection

  @create_attrs %{name: "some name", owner: "some owner"}
  @update_attrs %{name: "some updated name", owner: "some updated owner"}
  @invalid_attrs %{name: nil, owner: nil}

  def fixture(:collection) do
    {:ok, collection} = Catalog.create_collection(@create_attrs)
    collection
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all collections", %{conn: conn} do
      conn = get conn, collection_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create collection" do
    test "renders collection when data is valid", %{conn: conn} do
      conn = post conn, collection_path(conn, :create), collection: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, collection_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "owner" => "some owner"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, collection_path(conn, :create), collection: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update collection" do
    setup [:create_collection]

    test "renders collection when data is valid", %{conn: conn, collection: %Collection{id: id} = collection} do
      conn = put conn, collection_path(conn, :update, collection), collection: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, collection_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "owner" => "some updated owner"}
    end

    test "renders errors when data is invalid", %{conn: conn, collection: collection} do
      conn = put conn, collection_path(conn, :update, collection), collection: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete collection" do
    setup [:create_collection]

    test "deletes chosen collection", %{conn: conn, collection: collection} do
      conn = delete conn, collection_path(conn, :delete, collection)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, collection_path(conn, :show, collection)
      end
    end
  end

  defp create_collection(_) do
    collection = fixture(:collection)
    {:ok, collection: collection}
  end
end
