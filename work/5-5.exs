Enum.map([1,2,3,4], &(&1 + 2))
# Rubyの pp にあたるものがIO.inspectだって地味に先行ヒントくれてるの好き
Enum.each([1,2,3,4], &IO.inspect/1)
