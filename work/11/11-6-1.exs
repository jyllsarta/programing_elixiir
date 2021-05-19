defmodule StringFormatter do
  def capitalize_sentence(string) do
    String.split(string, ". ") |> Enum.map(&(String.capitalize/1)) |> Enum.join(". ")
  end
end

IO.puts(StringFormatter.capitalize_sentence("oh. a DOG. woof."))
