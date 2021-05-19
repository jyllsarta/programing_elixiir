defmodule CSVParser do
  def parse(filename) do
    {:ok, file} = File.open(filename) # こういう返し方をする奴を綺麗に |> でつなげることってできないんだろうか
    # ここでEnum使うのってもしや悪手？ Stream系ライブラリだけを使うのが正義なのかも
    IO.stream(file, :line) |> Enum.slice(1..-1) |> Enum.map(&parse_line/1)
  end

  defp parse_line(string) do
    [id, ship_to, net_amount] = String.split(string, ",") |> Enum.map(&(String.trim/1))
    trimmed_ship_to = String.replace(ship_to, ":", "")
    [id: String.to_integer(id), ship_to: String.to_atom(trimmed_ship_to), net_amount: String.to_float(net_amount) ]
  end
end

CSVParser.parse("taxes.csv") |> Enum.each(&IO.inspect/1)
# 良さそう
# [id: 123, ship_to: :NC, net_amount: 100.0]
# [id: 124, ship_to: :OK, net_amount: 35.5]
# [id: 125, ship_to: :TX, net_amount: 24.0]
# [id: 126, ship_to: :TX, net_amount: 44.8]
# [id: 127, ship_to: :NC, net_amount: 25.0]
# [id: 128, ship_to: :MA, net_amount: 10.0]
# [id: 129, ship_to: :CA, net_amount: 102.0]
# [id: 120, ship_to: :NC, net_amount: 50.0]
