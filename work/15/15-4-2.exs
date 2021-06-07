defmodule Parallel do
  def pmap(collection, fun) do
    me = self()
    collection
    |> Enum.map(fn (elem) ->
                  spawn_link fn -> (send me, {self(), fun.(elem)}) end
                end)
    |> Enum.map(fn (pid) ->
                  receive do {_pid, result} -> result end
                end)
  end
end 

Parallel.pmap 1..10, &(&1 * &1) |> IO.inspect

# わざわざ工夫せずとも即死しました
# これはまあ、プロセスの立ち上がり具合によって返事が来るタイミングがまちまちなので順序の保証がないのでそりゃそうだよね、という感じです
# 渡された数値の大きさに比例したsleepとかすると明らかになると思います

"""
[localhost] ~/programming_elixiir/work/15 % iex 15-4-2.exs
Erlang/OTP 23 [erts-11.1.8] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe] [dtrace]

warning: variable "pid" is unused (if the variable is not meant to be used, prefix it with an underscore)
  15-4-2.exs:8: Parallel.pmap/2

4
100
1
9
16
36
49
64
81
25
Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
BREAK: (a)bort (A)bort with dump (c)ontinue (p)roc info (i)nfo
       (l)oaded (v)ersion (k)ill (D)b-tables (d)istribution
^C%
"""

