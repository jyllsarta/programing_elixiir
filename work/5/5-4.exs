prefix = fn
  pref -> fn
    body -> "#{pref} #{body}"
  end
end
prefix.("Elixir").("Rocks") 
