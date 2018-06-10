defmodule Phelddagrif.Repo.Migrations.MakeCardsUniqueByScryfallId do
  use Ecto.Migration

  def change do
    create unique_index(:cards, [:scryfall_id])
  end
end
