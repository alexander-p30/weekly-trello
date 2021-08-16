defmodule WeeklyTrello.Parsers.Json do
  alias WeeklyTrello.Parsers.Json.Card

  def parse_cards_data_json(file_contents, token_values, opts) do
    Enum.map(file_contents, fn card_data ->
      card_data
      |> Map.new(fn {key, _} = key_value_pair ->
        key_value_pair
        |> Card.parse_card_field_value(token_values, opts)
        |> then(fn string_with_replaced_tokens -> {key, string_with_replaced_tokens} end)
      end)
      |> Map.put("idList", trello_board_list_id())
    end)
  end

  defp trello_board_list_id(), do: Application.get_env(:weekly_trello, :board_list_id)
end
