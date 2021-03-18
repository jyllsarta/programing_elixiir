defmodule Caesar do
  def caesar([], number) do
    []
  end
  # 'a' の 97 と 26 がキモいけど...練習問題だし...
  # 絶対合ってる
  # iex(2)>  Caesar.caesar('ryvkve',  13)
  # 'elixir'
  def caesar([head | tail], number) do
    new_head = rem(head - 97 + number, 26) + 97
    [new_head] ++ caesar(tail, number)
  end
end
