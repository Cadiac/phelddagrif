defmodule Phelddagrif.Atlas.CardImage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Phelddagrif.Atlas.Card

  schema "card_images" do
    field :last_modified, :utc_datetime
    field :illustration_id, :binary_id
    field :url, :string
    field :content_type, :string
    field :content_length, :integer
    field :primary, :boolean, default: true

    timestamps()

    belongs_to :card, Card, foreign_key: :card_id
  end

  @doc false
  def changeset(card_image, attrs) do
    card_image
    |> cast(attrs, [
      :last_modified,
      :illustration_id,
      :url,
      :content_type,
      :content_length,
      :primary
    ])
    |> validate_required([
      :last_modified,
      :url,
      :content_type,
      :content_length,
      :primary
    ])
  end
end
