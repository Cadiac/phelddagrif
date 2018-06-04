defmodule PhelddagrifWeb.PageController do
  use PhelddagrifWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
