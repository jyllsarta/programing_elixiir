defmodule AgreeBot do
  def ok!({:ok, data}) do
    data
  end
  def ok!(params) do
    raise "error: #{IO.inspect(params)}"
  end
end

file = AgreeBot.ok!(File.open("../11/taxes.csv"))
IO.stream(file, :line)|> IO.inspect
