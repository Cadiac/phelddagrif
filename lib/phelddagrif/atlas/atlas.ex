defmodule Phelddagrif.Atlas do
  @moduledoc """
  The Atlas context.
  """

  require Logger

  import Ecto.Query, warn: false
  alias Phelddagrif.Repo

  alias Phelddagrif.Atlas.Set
  alias Phelddagrif.Atlas.Card

  defp paginate(query, page, limit) do
    from(
      query,
      limit: ^limit,
      offset: ^((page - 1) * limit)
    )
  end

  @doc """
  Returns the list of sets.

  ## Examples

      iex> list_sets()
      [%Set{}, ...]

  """
  def list_sets do
    Repo.all(Set)
  end

  @doc """
  Gets a single set.

  Raises `Ecto.NoResultsError` if the Set does not exist.

  ## Examples

      iex> get_set!(123)
      %Set{}

      iex> get_set!(456)
      ** (Ecto.NoResultsError)

  """
  def get_set!(id), do: Repo.get!(Set, id)

  @doc """
  Gets a single set by its code.

  Raises `Ecto.NoResultsError` if the Set does not exist.

  ## Examples

      iex> get_set_by_code!("m19")
      %Set{}

      iex> get_set_by_code!("m24")
      ** (Ecto.NoResultsError)

  """
  def get_set_by_code!(code) do
    Repo.one!(
      from(
        s in Set,
        where: s.code == ^code
      )
    )
  end

  @doc """
  Creates a set.

  ## Examples

      iex> create_set(%{field: value})
      {:ok, %Set{}}

      iex> create_set(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_set(attrs \\ %{}) do
    %Set{}
    |> Set.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a set.

  ## Examples

      iex> update_set(set, %{field: new_value})
      {:ok, %Set{}}

      iex> update_set(set, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_set(%Set{} = set, attrs) do
    set
    |> Set.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Set.

  ## Examples

      iex> delete_set(set)
      {:ok, %Set{}}

      iex> delete_set(set)
      {:error, %Ecto.Changeset{}}

  """
  def delete_set(%Set{} = set) do
    Repo.delete(set)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking set changes.

  ## Examples

      iex> change_set(set)
      %Ecto.Changeset{source: %Set{}}

  """
  def change_set(%Set{} = set) do
    Set.changeset(set, %{})
  end

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(%{"set" => code} = attrs) do
    set = Phelddagrif.Atlas.get_set_by_code!(code)

    {:ok, card} =
      Ecto.build_assoc(set, :cards)
      |> Card.changeset(attrs)
      |> Repo.insert()

    {:ok, Repo.preload(card, [:set])}
  end

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards(0, 100)
      [%Card{}, ...]

  """
  def list_cards(page \\ 1, limit \\ 100) do
    cards =
      from(
        c in Card,
        order_by: [asc: c.id],
        preload: :set
      )
      |> paginate(page, limit)
      |> Repo.all()

    total_count =
      Repo.one(
        from(
          c in Card,
          select: count(c.id)
        )
      )

    %{total_count: total_count, has_more: page * limit < total_count, cards: cards}
  end

  @doc """
  Search cards containing search keyword

  ## Examples

      iex> search_cards("Squee", 1, 100)
      [%Card{}, ...]

  """
  def search_cards(term, page \\ 1, limit \\ 100) do
    wildcard_term = "%#{term}%"

    cards =
      from(
        c in Card,
        where: ilike(c.name, ^wildcard_term),
        or_where: ilike(c.type_line, ^wildcard_term),
        or_where: ilike(c.oracle_text, ^wildcard_term)
      )
      |> paginate(page, limit)
      |> Repo.all()
      # TODO: Do this with proper join, this executes another select query
      |> Repo.preload([set: (from s in Set, order_by: s.released_at)])

    total_count =
      Repo.one(
        from(
          c in Card,
          select: count(c.id),
          where: ilike(c.name, ^wildcard_term),
          or_where: ilike(c.type_line, ^wildcard_term),
          or_where: ilike(c.oracle_text, ^wildcard_term)
        )
      )

    %{total_count: total_count, has_more: page * limit < total_count, cards: cards}
  end

  @doc """
  Gets a single card by id.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id) do
    Repo.one!(
      from(
        c in Card,
        where: c.id == ^id,
        preload: :set
      )
    )
  end
end
