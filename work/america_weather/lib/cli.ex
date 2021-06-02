defmodule Americaweather.CLI do
  @moduledoc """
  shows america weather
  """
  def main(_argv) do
    process()
  end

  def process() do
    fetch()
    |> decode_response()
    |> show()
  end

  def fetch() do
    HTTPoison.get("https://w1.weather.gov/xml/current_obs/KDTO.xml")
  end

  # エラー処理はもう一旦いいや
  def decode_response({_, %{status_code: _status_code, body: body}}) do
    body
    |> :binary.bin_to_list()
  end

  # 何回もスキャンして何回もxpath検索するの絶対重いけどちょっと面倒すぎてしんどいので許して
  def parse(body, xpath_string) do
    char_list = xpath_string |> :binary.bin_to_list()
    {root, _} = :xmerl_scan.string(body)
    # このスーパー大雑把パターンマッチも絶対よくない
    [{:xmlText, _, _, _, text, :text}] = :xmerl_xpath.string(char_list, root)
    text
  end

  def show(body) do
    station = body |> parse("/current_observation/station_id/text()")
    temp = body |> parse("/current_observation/dewpoint_c/text()")
    weather = body |> parse("/current_observation/weather/text()")
    IO.puts("station: #{station} / temp: #{temp} / weather: #{weather}")
  end
end
