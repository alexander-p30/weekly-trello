defmodule WeeklyTrello.CLI do
  def main(_args \\ []), do: WeeklyTrello.create_weekly_cards()
end
