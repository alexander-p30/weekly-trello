defmodule WeeklyTrello.Parsers.Json.Card do
  @week_days_names ~w(monday tuesday wednesday thursday friday saturday sunday)

  def parse_card_field_value({"due", date}, _) do
    date
    |> set_due_datetime_if_not_set()
    |> DateTime.new(~T[22:00:00])
    |> then(fn {_, datetime} -> datetime end)
    |> DateTime.add(3600 * 3)
    |> DateTime.to_iso8601()
  end

  def parse_card_field_value({_, value}, token_values) when is_binary(value) do
    replace_tokens(value, token_values)
  end

  def parse_card_field_value({_, value}, _), do: value

  def replace_tokens(card_field_value, token_values) do
    get_replace_tokens()
    |> Enum.reduce(card_field_value, fn token, string ->
      String.replace(string, "$" <> token, token_values[token])
    end)
  end

  def set_due_datetime_if_not_set(nil) do
    friday = 5
    today = Date.utc_today()

    today
    |> Date.day_of_week()
    |> then(fn day_of_week ->
      if day_of_week > friday,
        do: Date.end_of_week(today),
        else: Date.add(today, friday - day_of_week)
    end)
  end

  def set_due_datetime_if_not_set(day_of_week) when day_of_week in @week_days_names do
    beginning_of_week_to_day_of_week =
      Enum.find_index(@week_days_names, fn week_day_name -> week_day_name == day_of_week end)

    Date.utc_today()
    |> Date.beginning_of_week()
    |> Date.add(beginning_of_week_to_day_of_week)
  end

  def set_due_datetime_if_not_set(set_value) do
    set_value
    |> Date.from_iso8601()
    |> then(fn {status, _} ->
      if status == :ok, do: set_value, else: set_due_datetime_if_not_set(nil)
    end)
  end

  def get_replace_tokens, do: Application.get_env(:weekly_trello, :replace_tokens)
end
