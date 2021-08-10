defmodule WeeklyTrello.Files.Import do
  def get_file_contents(file_path) do
    file_path
    |> File.read()
    |> then(fn {_, contents} -> contents end)
  end

  def file_contents_to_json(file_contents) do
    file_contents
    |> Jason.decode()
    |> then(fn {_, contents} -> contents end)
  end
end
