defmodule Phelddagrif.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset


  schema "collections" do
    field :name, :string
    field :owner, :string

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :owner])
    |> validate_required([:name, :owner])
  end
end
