defmodule Mix.Tasks.Data.Import do
  use Mix.Task
  require Logger

  # import Mix.Ecto

  alias Phelddagrif.Cards.Card

  @shortdoc "Imports card data using Scryfall API"
  def run(_) do
    Mix.Task.run("app.start")
    # ensure_started(Phelddagrif.Repo, [])

    Logger.info("Beginning data import")
    fetch_pages(true, "https://api.scryfall.com/cards")
    Logger.info("Import done!")
  end

  defp fetch_pages(has_more_pages, _url) when has_more_pages === false, do: Logger.info("Found the last page.")
  defp fetch_pages(has_more_pages, url) do
    Logger.info("GET #{url}")

    options = [recv_timeout: 60_000]

    case HTTPoison.get(url, [], options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = body |> Poison.decode!

        has_more_pages = Map.get(response, "has_more")
        next_page_url = Map.get(response, "next_page")

        # Insert cards to database
        response
        |> Map.get("data")
        |> Enum.map(fn(card) ->
          card_with_scryfall_id = Map.put_new(card, "scryfall_id", Map.get(card, "id"))

          operation = %Card{}
          |> Card.changeset(card_with_scryfall_id)
          |> Phelddagrif.Repo.insert()

          case operation do
            {:ok, inserted_card} ->
              Logger.info("Successfully inserted card #{inserted_card.scryfall_id}")
            {:error, err} ->
              Logger.error("Problem with card #{Map.get(card, "id")}: #{inspect err}")
          end
        end)

        Logger.info("Processed #{response |> Map.get("data") |> length} cards")

        # fetch_pages(has_more_pages, next_page_url)
      {:ok, %HTTPoison.Response{status_code: 429}} ->
        Logger.error("Hit rate limit, sleeping for a minute")
        Process.sleep(60_000)
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching cards: #{inspect reason}")
        Process.sleep(5000)
    end
  end
end
