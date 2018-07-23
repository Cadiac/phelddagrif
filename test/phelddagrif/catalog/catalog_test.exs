defmodule Phelddagrif.CatalogTest do
  use Phelddagrif.DataCase

  alias Phelddagrif.Catalog

  describe "collections" do
    alias Phelddagrif.Catalog.Collection

    @valid_attrs %{name: "some name", owner: "some owner"}
    @update_attrs %{name: "some updated name", owner: "some updated owner"}
    @invalid_attrs %{name: nil, owner: nil}

    def collection_fixture(attrs \\ %{}) do
      {:ok, collection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Catalog.create_collection()

      collection
    end

    test "list_collections/0 returns all collections" do
      collection = collection_fixture()
      assert Catalog.list_collections() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Catalog.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      assert {:ok, %Collection{} = collection} = Catalog.create_collection(@valid_attrs)
      assert collection.name == "some name"
      assert collection.owner == "some owner"
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      assert {:ok, collection} = Catalog.update_collection(collection, @update_attrs)
      assert %Collection{} = collection
      assert collection.name == "some updated name"
      assert collection.owner == "some updated owner"
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_collection(collection, @invalid_attrs)
      assert collection == Catalog.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Catalog.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Catalog.change_collection(collection)
    end
  end

  describe "collection_cards" do
    alias Phelddagrif.Catalog.CollectionCard

    @valid_attrs %{quantity: 42}
    @update_attrs %{quantity: 43}
    @invalid_attrs %{quantity: nil}

    def collection_card_fixture(attrs \\ %{}) do
      {:ok, collection_card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Catalog.create_collection_card()

      collection_card
    end

    test "list_collection_cards/0 returns all collection_cards" do
      collection_card = collection_card_fixture()
      assert Catalog.list_collection_cards() == [collection_card]
    end

    test "get_collection_card!/1 returns the collection_card with given id" do
      collection_card = collection_card_fixture()
      assert Catalog.get_collection_card!(collection_card.id) == collection_card
    end

    test "create_collection_card/1 with valid data creates a collection_card" do
      assert {:ok, %CollectionCard{} = collection_card} = Catalog.create_collection_card(@valid_attrs)
      assert collection_card.quantity == 42
    end

    test "create_collection_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_collection_card(@invalid_attrs)
    end

    test "update_collection_card/2 with valid data updates the collection_card" do
      collection_card = collection_card_fixture()
      assert {:ok, collection_card} = Catalog.update_collection_card(collection_card, @update_attrs)
      assert %CollectionCard{} = collection_card
      assert collection_card.quantity == 43
    end

    test "update_collection_card/2 with invalid data returns error changeset" do
      collection_card = collection_card_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_collection_card(collection_card, @invalid_attrs)
      assert collection_card == Catalog.get_collection_card!(collection_card.id)
    end

    test "delete_collection_card/1 deletes the collection_card" do
      collection_card = collection_card_fixture()
      assert {:ok, %CollectionCard{}} = Catalog.delete_collection_card(collection_card)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_collection_card!(collection_card.id) end
    end

    test "change_collection_card/1 returns a collection_card changeset" do
      collection_card = collection_card_fixture()
      assert %Ecto.Changeset{} = Catalog.change_collection_card(collection_card)
    end
  end
end
