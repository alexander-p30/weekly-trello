defmodule WeeklyTrello do
  @moduledoc """
  """

  alias WeeklyTrello.Adapters.TrelloApi
  alias WeeklyTrello.Files.Import, as: FilesImport
  alias WeeklyTrello.Parsers.Json, as: JsonParser

  @data_json_path "assets/json/cards.json"

  def create_weekly_cards() do
    get_user_values_for_tokens()
    |> mount_request_payload(prompt_user_for_opts_change())
    |> confirm_data_correctness()
  end

  def confirm_data_correctness(data) do
    IO.inspect(data)

    "Please, check the correctness of the cards data above. Is it correct?\ny/*: "
    |> IO.gets()
    |> String.trim()
    |> Kernel.==("y")
    |> then(fn
      true -> TrelloApi.create_cards(data)
      false -> nil
    end)
    |> then(fn _ -> IO.puts("") end)
  end

  def get_user_values_for_tokens() do
    get_replace_tokens()
    |> Map.new(fn token ->
      "Enter value for #{token}: "
      |> IO.gets()
      |> String.trim()
      |> then(fn token_value -> {token, token_value} end)
    end)
  end

  def prompt_user_for_opts_change() do
    currently_set_opts = get_opts()

    currently_set_opts
    |> Enum.map(fn {opt_name, _opt_value} -> opt_name end)
    |> Enum.join(", ")
    |> then(&"Would you like to change any options? Current available options are #{&1}\ny/*: ")
    |> IO.gets()
    |> String.trim()
    |> Kernel.==("y")
    |> then(fn
      true -> get_user_values_for_opts(currently_set_opts)
      false -> currently_set_opts
    end)
  end

  def get_user_values_for_opts(opts) do
    opts
    |> Enum.map(fn {opt_name, _opt_value} ->
      opt_name
      |> then(&"Enter value for #{&1}: ")
      |> IO.gets()
      |> String.trim()
      |> then(&{opt_name, &1})
    end)
    |> Keyword.new()
  end

  def mount_request_payload(token_values, opts \\ []) do
    @data_json_path
    |> FilesImport.get_file_contents()
    |> FilesImport.file_contents_to_json()
    |> JsonParser.parse_cards_data_json(token_values, opts)
  end

  def get_replace_tokens, do: Application.get_env(:weekly_trello, :replace_tokens)
  def get_opts, do: Application.get_env(:weekly_trello, :opts)
end
