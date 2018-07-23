defmodule Phelddagrif.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :string
      add :owner, :string

      timestamps()
    end

  end
end
