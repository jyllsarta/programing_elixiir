# これだと微妙にList.flattenと挙動が違う
# List.flatten(5) は FunctionClauseErrorだが、こいつは [5] を返す
defmodule MyList do
  def flatten([]) do
    []
  end
  def flatten([head]) do
    flatten(head)
  end
  def flatten([head | tail]) when head == [] do
    flatten(tail)
  end
  def flatten([head | tail]) when tail == []  do
    flatten(head)
  end
  def flatten([head | tail]) do
    flatten(head) ++ flatten(tail)
  end
  def flatten(head) do
    [head]
  end
end

IO.inspect(MyList.flatten([ 1, [2, 3, [4]], 5, [[[6]]]]))
