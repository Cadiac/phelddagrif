defmodule Mix.Tasks.Data.Import do
  use Mix.Task
  use Timex

  require Logger
  alias Phelddagrif.Atlas

  @api_options [recv_timeout: 60_000]
  @sets_api_url "https://api.scryfall.com/sets"
  @cards_bulk_url "https://archive.scryfall.com/json/scryfall-oracle-cards.json"

  @shortdoc "Imports card data using Scryfall API"
  def run(_) do
    Mix.Task.run("app.start")
    import_data()
  end

  def import_data() do
    Logger.info("Beginning data import")
    Logger.info("Importing sets")
    # fetch_sets()
    Logger.info("Importing cards")
    fetch_cards_bulk()
    Logger.info("Import done!")
  end

  defp fetch_sets() do
    case HTTPoison.get(@sets_api_url, [], @api_options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get("data")
        |> Enum.map(fn set ->
          case Atlas.upsert_set(set) do
            {:ok, inserted_set} ->
              Logger.info("Successfully inserted set #{inserted_set.code}")

            {:error, err} ->
              Logger.error("Problem with set #{Map.get(set, "code")}: #{inspect(err)}")
          end
        end)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("Got unknown status_code #{status_code}: #{inspect(body)}")
        Process.sleep(60_000)

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching sets: #{inspect(reason)}")
        Process.sleep(5000)
    end
  end

  defp fetch_cards_bulk() do
    case HTTPoison.get(@cards_bulk_url, [], @api_options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = body |> Poison.decode!()

        # Insert cards to database
        response
        |> Enum.map(fn card ->
          card_with_scryfall_id = Map.put_new(card, "scryfall_id", Map.get(card, "id"))

          with {:ok, inserted_card} <- Atlas.upsert_card(card_with_scryfall_id) do
            Logger.info("Successfully inserted card #{inserted_card.scryfall_id}")

            case fetch_card_image(inserted_card) do
              :ok ->
                Logger.info("Successfully downloaded card image.")

              {:error, err} ->
                Logger.error("Failed to download card #{card.id} image: #{inspect(err)}")
            end
          end
        end)

        Logger.info("Processed #{response |> length} cards")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching bulk cards: #{inspect(reason)}")
    end
  end

  defp download_and_save_image(image_uris, name, quality \\ "normal") do
    url = Map.get(image_uris, quality)

    case HTTPoison.head(url, [], @api_options) do
      {:ok, %HTTPoison.Response{status_code: 200, headers: headers}} ->
        {_key, last_modified} = List.keyfind(headers, "Last-Modified", 0)
        last_modified_date = Timex.parse(last_modified, "{RFC1123}")
        :ok
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching bulk cards HEAD: #{inspect(reason)}")
        {:error, reason}
    end

    case HTTPoison.get(url, [], @api_options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        File.write!("priv/static/images/#{name}.jpg", body)
        :ok

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching bulk cards GET: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp fetch_card_image(%Phelddagrif.Atlas.Card{layout: layout, card_faces: [front, back]} = card)
       when layout == "transform" do
    with :ok <- Map.get(front, "image_uris") |> download_and_save_image(card.id),
         :ok <- Map.get(back, "image_uris") |> download_and_save_image("#{card.id}-back") do
      :ok
    else
      err -> err
    end
  end

  defp fetch_card_image(%Phelddagrif.Atlas.Card{image_uris: image_uris}) when is_nil(image_uris),
    do: :ok

  defp fetch_card_image(%Phelddagrif.Atlas.Card{image_uris: image_uris} = card) do
    download_and_save_image(image_uris, card.id)
  end
end
