defmodule Max do
  # Max.max([]) をマッチさせずにエラーにしてしまうのは意図通りなんだろうか？
  # rubyぽい挙動をさせるなら `[].max` は `nil` を返させるのが妥当なんだろうけど、なんか驚くべきことにiexの世界では 1 < nil == trueで、例えば
  #  def max([head]) do
  #    nil
  #  end
  # なんて宣言すると全部nilに飲まれていって常にnilを返すメソッドができてしまった...なのでこうするしかないかなって感じ
  def max([head]) do
    head
  end
  def max([head | tail]) do
    tail_max = max(tail)
    if head > tail_max do
      head
    else
      tail_max
    end
  end
end
