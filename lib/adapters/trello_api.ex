defmodule WeeklyTrello.Adapters.TrelloApi do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.trello.com/1/cards")
  plug(Tesla.Middleware.JSON)

  def create_cards([_ | _] = cards_params), do: Enum.map(cards_params, &create_card/1)
  def create_cards(%{} = card_params), do: Enum.map([card_params], &create_card/1)

  def create_card(card_params) do
    ""
    |> post(card_params, query: [key: trello_api_key(), token: trello_api_token()])
    |> then(fn
      {:ok, _} -> IO.write("\x1b[32m.\x1b[0m")
      {:error, _} -> IO.write("\x1b[31mx\x1b[0m")
    end)
  end

  defp trello_api_key(), do: Application.get_env(:weekly_trello, :api_key)
  defp trello_api_token(), do: Application.get_env(:weekly_trello, :api_token)
end
