defmodule PhelddagrifWeb.SetController do
  use PhelddagrifWeb, :controller

  alias Phelddagrif.Atlas

  action_fallback PhelddagrifWeb.FallbackController

  def index(conn, _params) do
    sets = Atlas.list_sets()
    render(conn, "index.json", sets: sets)
  end

  def show(conn, %{"id" => id}) do
    set = Atlas.get_set!(id)
    render(conn, "show.json", set: set)
  end
end
