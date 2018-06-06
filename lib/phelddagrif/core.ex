defmodule Phelddagrif.Core do
  @moduledoc """
  Core API logic
  """

  require Logger
  import Ecto.Query, warn: false
  alias Phelddagrif.Repo

  alias Phelddagrif.Cards.Card

  defp paginate(query, page, limit) do
    from query,
      limit: ^limit,
      offset: ^((page-1) * limit)
  end

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
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
      where: c.id == ^id
    )
  end
end
