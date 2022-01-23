defmodule WeeklyTrello.MixProject do
  use Mix.Project

  def project do
    [
      app: :weekly_trello,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  defp escript do
    [main_module: WeeklyTrello.CLI]
  end

  def application do
    [
      extra_applications: [:logger],
      env: [
        api_key: System.get_env("TRELLO_API_KEY"),
        api_token: System.get_env("TRELLO_API_TOKEN"),
        board_list_id: System.get_env("TRELLO_BOARD_LIST_ID"),
        replace_tokens: ["current_week"],
        opts: [deadline_week: "0"]
      ]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"}
    ]
  end
end
