defmodule Mix.Tasks.Data.Import do
  use Mix.Task
  require Logger

  alias Phelddagrif.Atlas

  @shortdoc "Imports card data using Scryfall API"
  def run(_) do
    Mix.Task.run("app.start")
    import_data()
  end

  def import_data() do
    Logger.info("Beginning data import")
    Logger.info("Importing sets")
    fetch_sets()
    Logger.info("Importing cards")
    fetch_pages(true, "https://api.scryfall.com/cards")
    Logger.info("Import done!")
  end

  defp fetch_sets() do
    url = "https://api.scryfall.com/sets"
    options = [recv_timeout: 60_000]

    Logger.info("GET #{url}")

    case HTTPoison.get(url, [], options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!
        |> Map.get("data")
        |> Enum.map(fn(set) ->
          case Atlas.create_set(set) do
            {:ok, inserted_set} ->
              Logger.info("Successfully inserted set #{inserted_set.code}")
            {:error, err} ->
              Logger.error("Problem with set #{Map.get(set, "code")}: #{inspect err}")
          end
        end)
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("Got unknown status_code #{status_code}: #{inspect body}")
        Process.sleep(60_000)
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching sets: #{inspect reason}")
        Process.sleep(5000)
      {:error, err} ->
        Logger.error("Unknown error #{inspect err}")
        Process.sleep(5000)
    end
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
        |> Enum.filter(fn(card) -> Map.get(card, "lang") == "en" end)
        |> Enum.map(fn(card) ->
          card_with_scryfall_id = Map.put_new(card, "scryfall_id", Map.get(card, "id"))

          case Atlas.create_card(card_with_scryfall_id) do
            {:ok, inserted_card} ->
              Logger.info("Successfully inserted card #{inserted_card.scryfall_id}")
            {:error, err} ->
              Logger.error("Problem with card #{Map.get(card, "id")}: #{inspect err}")
          end
        end)

        Logger.info("Processed #{response |> Map.get("data") |> length} cards")

        fetch_pages(has_more_pages, next_page_url)
      {:ok, %HTTPoison.Response{status_code: 429}} ->
        Logger.error("Hit rate limit, sleeping for a minute")
        Process.sleep(60_000)
        fetch_pages(has_more_pages, url)
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("Got unknown status_code #{status_code}: #{inspect body}")
        Process.sleep(60_000)
        fetch_pages(has_more_pages, url)
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching cards: #{inspect reason}")
        Process.sleep(5000)
        fetch_pages(has_more_pages, url)
      {:error, err} ->
        Logger.error("Unknown error #{inspect err}")
        Process.sleep(5000)
        fetch_pages(has_more_pages, url)
    end
  end
end
