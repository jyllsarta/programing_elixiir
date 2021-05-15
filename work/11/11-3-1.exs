defmodule AsciiPrinter do
  def printable?('') do
    true
  end
  def printable?([char | tail]) do
    ?\s <= char && char <= ?~ && printable?(tail)
  end
end

IO.puts(AsciiPrinter.printable?('もaa'))
# -> false

IO.puts(AsciiPrinter.printable?('*elixir*'))
# -> true
