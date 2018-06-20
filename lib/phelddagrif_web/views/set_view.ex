defmodule PhelddagrifWeb.SetView do
  use PhelddagrifWeb, :view
  alias PhelddagrifWeb.SetView

  def render("index.json", %{sets: sets}) do
    %{data: render_many(sets, SetView, "set.json")}
  end

  def render("show.json", %{set: set}) do
    %{data: render_one(set, SetView, "set.json")}
  end

  def render("set.json", %{set: set}) do
    %{id: set.id,
      code: set.code,
      mtgo_code: set.mtgo_code,
      name: set.name,
      set_type: set.set_type,
      released_at: set.released_at,
      block_code: set.block_code,
      block: set.block,
      parent_set_code: set.parent_set_code,
      card_count: set.card_count,
      digital: set.digital,
      foil_only: set.foil_only,
      icon_svg_uri: set.icon_svg_uri,
      search_uri: set.search_uri
    }
  end
end
