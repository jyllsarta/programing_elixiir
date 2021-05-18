defmodule StringFormatter do
  def center(string_list) do
    max_length = Enum.map(string_list, &String.length/1) |> Enum.max
    Enum.map(string_list, &(puts_to_center(&1, max_length)))
  end

  defp puts_to_center(string, width) do
    pad_length = div(width + String.length(string), 2)
    padded = String.pad_leading(string, pad_length)
    IO.puts(padded)
  end
end

StringFormatter.center(["is", "this", "well", "centered?", "...", "oh", "ωgoodω", "good job!", "---------------"])
