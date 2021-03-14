# memo の存在に気づくまで相当時間かかった
defmodule Chop do
  def guess(actual, range) do
    a..b = range
    helper(actual, a, b, div(a+b, 2))
  end

  def helper(actual, _, _, memo) when actual == memo do
    IO.puts("Is it #{memo}")
    actual
  end

  def helper(actual, _, b, memo) when actual > memo do
    IO.puts("Is it #{memo}? too small")
    helper(actual, memo + 1, b, div(memo + 1 + b, 2))
  end

  def helper(actual, a, _, memo) when actual < memo do
    IO.puts("Is it #{memo}? too large")
    helper(actual, a, memo - 1, div(a + memo - 1, 2))
  end
end
