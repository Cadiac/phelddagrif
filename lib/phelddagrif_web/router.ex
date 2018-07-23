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

    resources "/cards", CardController, only: [:index, :show]
    resources "/sets", SetController, only: [:index, :show]
    resources "/collections", CollectionController, only: [:index, :show, :create, :update, :delete]
    resources "/collections/cards", CollectionCardController, only: [:index, :show, :create, :update, :delete]
  end
end
