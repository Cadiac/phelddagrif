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
    fetch_sets()
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

            case update_card_image(inserted_card) do
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

  defp maybe_download_image(image_uris, card, name, primary \\ true)

  defp maybe_download_image(
         %{"normal" => url},
         %Phelddagrif.Atlas.Card{card_images: card_images} = card,
         name,
         primary
       )
       when is_nil(card_images) do
    download_and_save_image(url, card, name, primary)
  end

  defp maybe_download_image(
         %{"normal" => url},
         %Phelddagrif.Atlas.Card{card_images: card_images} = card,
         name,
         primary
       ) do
    case HTTPoison.head(url, [], @api_options) do
      {:ok, %HTTPoison.Response{status_code: 200, headers: headers}} ->
        {_key, date} = List.keyfind(headers, "Last-Modified", 0)
        {:ok, image_last_modified} = Timex.parse(date, "{RFC1123}")

        image_already_downloaded =
          Enum.any?(card_images, fn image ->
            Timex.equal?(image.last_modified, image_last_modified)
          end)

        if image_already_downloaded do
          Logger.info("Image #{name} already downloaded, skipping")
          :ok
        else
          Logger.info("Different timestamps, fetching image")
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching bulk cards HEAD: #{inspect(reason)}")
        {:error, reason}
    end

    download_and_save_image(url, card, name, primary)
  end

  defp download_and_save_image(url, %{illustration_id: illustration_id} = card, name, primary) do
    case HTTPoison.get(url, [], @api_options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        with {_, content_type} <- List.keyfind(headers, "Content-Type", 0),
             {_, content_length} <- List.keyfind(headers, "Content-Length", 0),
             {_, date} <- List.keyfind(headers, "Last-Modified", 0) do
          {:ok, last_modified} = Timex.parse(date, "{RFC1123}")

          relative_url = "/images/cards/#{name}"
          card_images_dir = System.get_env("CARD_IMAGES_DIR") || raise "expected the CARD_IMAGES_DIR environment variable to be set"
          File.write!("#{card_images_dir}/#{name}", body)

          Atlas.upsert_card_image(card, %{
            last_modified: last_modified,
            illustration_id: illustration_id,
            url: relative_url,
            content_type: content_type,
            content_length: content_length,
            primary: primary
          })
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("API error while fetching bulk cards GET: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp update_card_image(
         %Phelddagrif.Atlas.Card{layout: layout, card_faces: [front, back]} = card
       )
       when layout == "transform" do
    with {:ok, _image} <- Map.get(front, "image_uris") |> maybe_download_image(card, "#{card.id}.jpg"),
         {:ok, _image} <-
           Map.get(back, "image_uris") |> maybe_download_image(card, "#{card.id}-back.jpg", false) do
      :ok
    else
      err -> err
    end
  end

  defp update_card_image(%Phelddagrif.Atlas.Card{image_uris: image_uris}) when is_nil(image_uris),
    do: :ok

  defp update_card_image(%Phelddagrif.Atlas.Card{image_uris: image_uris} = card) do
    {:ok, _image} = maybe_download_image(image_uris, card, "#{card.id}.jpg")
    :ok
  end
end
