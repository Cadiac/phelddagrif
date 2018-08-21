defmodule PhelddagrifWeb.Router do
  use PhelddagrifWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", PhelddagrifWeb do
    pipe_through :api

    resources "/atlas/cards", CardController, only: [:index, :show]
    get "/atlas/search", CardController, :search
    resources "/atlas/sets", SetController, only: [:index, :show]
    resources "/collections", CollectionController, only: [:index, :show, :create, :update, :delete] do
      resources "/cards", CollectionCardController, only: [:index, :create]
    end
  end
end
