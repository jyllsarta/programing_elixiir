defmodule MyList do
  def span(from, to) when from <= to do
    [from] ++ span(from + 1, to)
  end
  def span(_, _) do
    []
  end
end

defmodule MyPrime do
  def primes(n) when 2 < n do
    # すごい素朴な定義通りの書き方だけど、とりあえずこれで動いてくれるはず
    for x <- MyList.span(2, n), Enum.all?(MyList.span(2, x-1), &( rem(x, &1) !== 0 )), do: x
  end
end

IO.inspect MyPrime.primes(100)
