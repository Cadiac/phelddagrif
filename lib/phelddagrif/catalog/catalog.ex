defmodule Phelddagrif.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Phelddagrif.Repo
  alias Phelddagrif.Catalog.Collection
  alias Phelddagrif.Catalog.CollectionCard

  @doc """
  Returns the list of collections.

  ## Examples

      iex> list_collections()
      [%Collection{}, ...]

  """
  def list_collections do
    Repo.all(
      from collection in Collection,
      left_join: card in CollectionCard,
      on: card.collection_id == collection.id,
      group_by: [collection.id, collection.name, collection.owner],
      select: %{
        id: collection.id,
        name: collection.name,
        owner: collection.owner,
        total_cards: fragment("SUM(COALESCE(quantity, 0))"),
        unique_cards: count(card.id)
      }
    )
  end

  @doc """
  Gets a single collection.

  Raises `Ecto.NoResultsError` if the Collection does not exist.

  ## Examples

      iex> get_collection!(123)
      %Collection{}

      iex> get_collection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection!(id), do: Repo.get!(Collection, id)

  @doc """
  Gets a collection with its card counts.

  Raises `Ecto.NoResultsError` if the Collection does not exist.

  ## Examples

      iex> get_collection_with_counts!(123)
      %Collection{}

      iex> get_collection_with_counts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection_with_counts!(id) do
    Repo.one(
      from collection in Collection,
      where: collection.id == ^id,
      left_join: card in CollectionCard,
      on: card.collection_id == collection.id,
      group_by: [collection.id, collection.name, collection.owner],
      select: %{
        id: collection.id,
        name: collection.name,
        owner: collection.owner,
        total_cards: fragment("SUM(COALESCE(quantity, 0))"),
        unique_cards: count(card.id)
      }
    )
  end

  @doc """
  Creates a collection.

  ## Examples

      iex> create_collection(%{field: value})
      {:ok, %Collection{}}

      iex> create_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection.

  ## Examples

      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}

      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Collection.

  ## Examples

      iex> delete_collection(collection)
      {:ok, %Collection{}}

      iex> delete_collection(collection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection changes.

  ## Examples

      iex> change_collection(collection)
      %Ecto.Changeset{source: %Collection{}}

  """
  def change_collection(%Collection{} = collection) do
    Collection.changeset(collection, %{})
  end

  @doc """
  Returns the list of collection_cards.

  ## Examples

      iex> list_collection_cards()
      [%CollectionCard{}, ...]

  """
  def list_collection_cards(collection_id) do
    Repo.all(
      from c in CollectionCard,
      where: c.collection_id == ^collection_id,
      preload: [card: :set]
    )
  end

  @doc """
  Gets a single collection card by card_id and collection_id

  Returns nil if it doesn't exist

  ## Examples

      iex> get_collection_card(123, 456)
      %CollectionCard{}

      iex> get_collection_card(123, 456)
      nil

  """
  def get_collection_card(card_id, collection_id) do
    Repo.one(
      from c in CollectionCard,
      where: c.card_id == ^card_id,
      where: c.collection_id == ^collection_id
    )
  end

  @doc """
  Adds one or more copies of a new card to collection.
  """
  def add_card_to_collection(collection_id, %{"card_id" => card_id, "quantity" => quantity}) do
    # Do card and collection exist?
    with card <- Phelddagrif.Atlas.get_card!(card_id) |> Repo.preload(:collections),
         collection <- Phelddagrif.Catalog.get_collection!(collection_id) |> Repo.preload(:cards)
    do
      # Update quantity or add new card to collection
      case Phelddagrif.Catalog.get_collection_card(card_id, collection_id) do
        %CollectionCard{} = collection_card ->
          collection_card
          |> CollectionCard.changeset(%{"quantity" => quantity})
          |> Repo.update()
        nil ->
          collection
          |> Ecto.build_assoc(:collection_cards)
          |> CollectionCard.changeset(%{"quantity" => quantity})
          |> Ecto.Changeset.put_assoc(:card, card)
          |> Repo.insert()
      end
    end
  end
end
