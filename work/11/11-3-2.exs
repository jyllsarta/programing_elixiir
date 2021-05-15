defmodule AnagramChecker do
  def anagram?(word1,word2) do
    Enum.sort(word1) == Enum.sort(word2) 
  end
end

IO.puts(AnagramChecker.anagram?('cat', 'act'))
# -> true

IO.puts(AnagramChecker.anagram?('bass kick', 'kick bass'))
# -> true

IO.puts(AnagramChecker.anagram?('amuro', 'roam'))
# -> false

IO.puts(AnagramChecker.anagram?('123456789', '987654321'))
# -> true

IO.puts(AnagramChecker.anagram?('123456789', '87654321'))
# -> false

