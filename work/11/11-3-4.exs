defmodule AlithmeticCalcurator do
  def calc(string) do
    separate(string) |> process
  end

  defp separate(string) do
    #[num1, ?\s, operand, ?\s, num2] = string で勝ちじゃんと思ってたんですが、num1とnum2が二桁以上が発生しうるんでした...
    # https://hexdocs.pm/elixir/Enum.html#chunk_by/2
    # Splits enumerable on every element for which fun returns a new value.
    # こいつがパーフェクトなハマり方をしますね。
    # 要件的には演算子と数値の間に必ず半角スペースがいるっぽいので、スペースでsplitみたいなことをしちゃいましょう
    [num1, [?\s], operand, [?\s], num2] = Enum.chunk_by(string, &(&1 == ?\s))
    [Parse.number(num1), operand, Parse.number(num2)]
  end

  defp process([num1, [?+], num2]) do
    num1 + num2
  end
  defp process([num1, [?*], num2]) do
    num1 * num2
  end
  defp process([num1, [?-], num2]) do
    num1 - num2
  end
  defp process([num1, [?/], num2]) do
    num1 / num2
  end
end

# これは教材からのコピペ
defmodule Parse do  
  def number([ ?- | tail]), do: _number_digits(tail, 0) * -1  
  def number([ ?+ | tail]), do: _number_digits(tail, 0)  
  def number(str), do: _number_digits(str, 0)  
  defp _number_digits([], value), do: value  
  defp _number_digits([ digit | tail], value)  when digit 
    in '0123456789' do 
      _number_digits(tail, value*10 + digit - ?0)
  end  
  defp _number_digits([ non_digit | _],  _) do  
    raise "Invalid digit '#{[non_digit]}'"  
  end
end 

IO.puts(AlithmeticCalcurator.calc('1 + 14'))
IO.puts(AlithmeticCalcurator.calc('100 * 1000'))
IO.puts(AlithmeticCalcurator.calc('123 - 123'))
IO.puts(AlithmeticCalcurator.calc('100 / 5'))
# 15
# 100000
# 0
# 20.0
# よさそうです