defmodule MyList do
  def span(from, to) when from <= to do
    [from] ++ span(from + 1, to)
  end
  def span(_, _) do
    []
  end
end
