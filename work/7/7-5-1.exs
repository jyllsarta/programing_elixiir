defmodule MapSum do
  def mapsum([], function) do
    0
  end
  def mapsum([head | tail], function) do
    function.(head) + mapsum(tail, function)
  end
end
