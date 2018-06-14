defmodule Phelddagrif.Atlas.Set do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:code, :string, []}
  @derive {Phoenix.Param, key: :code}
  schema "sets" do
    field :mtgo_code, :string
    field :name, :string
    field :set_type, :string
    field :released_at, :date
    field :block_code, :string
    field :block, :string
    field :parent_set_code, :string
    field :card_count, :integer
    field :digital, :boolean, default: false
    field :foil_only, :boolean, default: false
    field :icon_svg_uri, :string
    field :search_uri, :string

    timestamps()
  end

  @doc false
  def changeset(set, attrs) do
    set
    |> cast(attrs, [
      :code,
      :mtgo_code,
      :name,
      :set_type,
      :released_at,
      :block_code,
      :block,
      :parent_set_code,
      :card_count,
      :digital,
      :foil_only,
      :icon_svg_uri,
      :search_uri
    ])
    |> validate_required([
      :code,
      :name,
      :set_type,
      :card_count,
      :digital,
      :foil_only,
      :icon_svg_uri,
      :search_uri
    ])
  end
end
