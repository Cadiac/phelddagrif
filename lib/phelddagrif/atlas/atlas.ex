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
    from query,
      limit: ^limit,
      offset: ^((page-1) * limit)
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
      from s in Set,
      where: s.code == ^code
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

    {:ok, card} = Ecto.build_assoc(set, :cards)
    |> Card.changeset(attrs)
    |> Repo.insert()

    {:ok, Repo.preload(card, [:set])}
  end

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards(page, limit) do
    Repo.all(
      from c in Card,
      select: c,
      order_by: [asc: c.id],
      limit: ^limit,
      offset: ^((page-1) * limit),
      preload: :set
    )
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
      from c in Card,
      where: c.id == ^id,
      preload: :set
    )
  end
end
