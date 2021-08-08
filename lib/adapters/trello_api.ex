defmodule WeeklyTrello.Adapters.TrelloApi do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.trello.com/1/cards")
  plug(Tesla.Middleware.JSON)

  def req(payload) do
    Enum.map(payload, fn card_params ->
      post("", card_params, query: [key: trello_api_key(), token: trello_api_token()])
    end)
  end

  defp trello_api_key(), do: Application.get_env(:weekly_trello, :api_key)
  defp trello_api_token(), do: Application.get_env(:weekly_trello, :api_token)
end
