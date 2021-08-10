defmodule WeeklyTrello do
  @moduledoc """
  """

  alias WeeklyTrello.Adapters.TrelloApi
  alias WeeklyTrello.Files.Import, as: FilesImport
  alias WeeklyTrello.Parsers.Json, as: JsonParser

  @data_json_path "assets/json/cards.json"

  def create_weekly_cards() do
    get_user_values_for_replacement()
    |> mount_request_payload()
    |> TrelloApi.create_cards()
  end

  def get_user_values_for_replacement() do
    get_replace_tokens()
    |> Map.new(fn token ->
      "Enter value for #{token}: "
      |> IO.gets()
      |> String.trim()
      |> then(fn token_value -> {token, token_value} end)
    end)
  end

  def mount_request_payload(token_values) do
    @data_json_path
    |> FilesImport.get_file_contents()
    |> FilesImport.file_contents_to_json()
    |> JsonParser.parse_cards_data_json(token_values)
  end

  def get_replace_tokens, do: Application.get_env(:weekly_trello, :replace_tokens)
end
