defmodule MyEnum do
  def all?([], _) do
    true
  end
  def all?([head | tail], func) do
    func.(head) && all?(tail, func)
  end

  # each と map の挙動の違いを伝えようとしているのを感じる 
  def each([], _) do
    :ok
  end
  def each([head | tail], func) do
    func.(head)
    each(tail, func)
  end

  def filter([], _) do
    []
  end
  def filter([head | tail], func) do
    if func.(head) do
      [head] ++ filter(tail, func)
    else
      filter(tail, func)
    end
  end

  # at を使うと簡単なような気もするが、多分反則
  # なんかだいぶ苦しい感じになってしまった
  # なにこの挙動！！！！ これも実装しなきゃいけないの！？
  # Enum.split([1,2,3,4,5], -1)
  # {[1, 2, 3, 4], [5]}
  def split([], _) do
    {[],[]}
  end
  def split(list, 0) do
    {[], list}
  end
  def split(list, number) when number > 0 do
    [head | tail] = list
    {split_head, split_tail} = split(tail, number - 1)
    {[head] ++ split_head, split_tail}
  end
  def split(list, number) when number < 0 do
    # このEnum.reverseは反則なはずなんだけど標準の方法で尻尾を取る方法がわからない
    [last | reversed] = Enum.reverse(list)
    {split_head, split_tail} = split(Enum.reverse(reversed), number + 1)
    {split_head, split_tail ++ [last]}
  end

  # こいつもマイナスを受け取りよる！
  def take(_, 0) do
    []
  end
  def take(list, number) when number > 0 do
    [head | tail] = list
    [head] ++ take(tail, number - 1)
  end
  def take(list, number) when number < 0 do
    # このEnum.reverseは反則なはずなんだけど標準の方法で尻尾を取る方法がわからない
    [last | reversed] = Enum.reverse(list)
    take(Enum.reverse(reversed), number + 1) ++ [last]
  end
end
