defmodule Sequence.Stack.Server do
  use GenServer

  # 以下は API

  def start_link(items) do
    IO.inspect __MODULE__
    GenServer.start_link(__MODULE__, items, name: __MODULE__)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def inspect() do
    GenServer.cast(__MODULE__, :inspect)
  end

  # 以下は GenServer

  def init(items) do
    IO.puts("---復活---")
    {:ok, items}
  end

  def handle_call(:pop, _from, items) do
    [ head | tail ] = items
    if head == 777777 do
      IO.puts("777777をpopするときだけ6秒sleepします")
      :timer.sleep(6000)
    end
    {:reply, head, tail}
  end

  def handle_cast(:inspect, items) do
    IO.inspect(items)
    {:noreply, items}
  end

  def handle_cast({:push, item}, items) when item < 10 do
    IO.puts("小さい数字をもらったら死ぬようにプログラムされているんだ")
    System.halt(1)
    {:noreply, items ++ [item]}
  end

  def handle_cast({:push, item}, items) when item == 999999 do
    IO.puts("999999をもらったら寝すぎて死にます") # これは死ななかった。castはどれだけ遅くても許されるみたい
    :timer.sleep(5001)
    {:noreply, items ++ [item]}
  end

  def handle_cast({:push, item}, _items) when item == 888888 do
    IO.puts("888888をもらったら変なものをreturnして死にます")
    {:bad_return_value} # これは死んだ...がterminateしてくれなかった
  end

  def handle_cast({:push, item}, items) do
    {:noreply, items ++ [item]}
  end

  def terminate(reason, state) do
    IO.puts("ウワーッ 死にます これから")
    IO.inspect(reason)
    IO.inspect(state)
  end
end

"""
Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> r Sequence.Stack.Server
iex(10)> warning: redefining module Sequence.Stack.Server (current version defined in memory)
  lib/stack/server.ex:1

{:reloaded, Sequence.Stack.Server, [Sequence.Stack.Server]}
iex(2)>  {:ok, pid} = GenServer.start_link(Sequence.Stack.Server, [1001, 41, 51])
{:ok, #PID<0.226.0>}
iex(3)> GenServer.cast(pid, {:push, 5})
:ok
iex(4)> GenServer.cast(pid, {:push, 5})
:ok
iex(5)> GenServer.call(pid, :pop)
1001
iex(6)> GenServer.call(pid, :pop)
41
iex(7)> GenServer.call(pid, :pop)
51
iex(8)> GenServer.call(pid, :pop)
5
iex(9)> GenServer.call(pid, :pop)
5
iex(10)> GenServer.call(pid, :pop)
iex(10)>
17:59:31.178 [error] GenServer #PID<0.226.0> terminating
** (MatchError) no match of right hand side value: []
    (sequence 0.1.0) lib/stack/server.ex:7: Sequence.Stack.Server.handle_call/3
    (stdlib 3.14) gen_server.erl:715: :gen_server.try_handle_call/4
    (stdlib 3.14) gen_server.erl:744: :gen_server.handle_msg/6
    (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message (from #PID<0.217.0>): :pop
State: []
Client #PID<0.217.0> is alive

    (stdlib 3.14) gen.erl:208: :gen.do_call/4
    (elixir 1.11.3) lib/gen_server.ex:1024: GenServer.call/3
    (stdlib 3.14) erl_eval.erl:680: :erl_eval.do_apply/6
    (elixir 1.11.3) src/elixir.erl:280: :elixir.recur_eval/3
    (elixir 1.11.3) src/elixir.erl:265: :elixir.eval_forms/3
    (iex 1.11.3) lib/iex/evaluator.ex:261: IEx.Evaluator.handle_eval/5
    (iex 1.11.3) lib/iex/evaluator.ex:242: IEx.Evaluator.do_eval/3
    (iex 1.11.3) lib/iex/evaluator.ex:220: IEx.Evaluator.eval/3
** (EXIT from #PID<0.217.0>) shell process exited with reason: an exception was raised:
    ** (MatchError) no match of right hand side value: []
        (sequence 0.1.0) lib/stack/server.ex:7: Sequence.Stack.Server.handle_call/3
        (stdlib 3.14) gen_server.erl:715: :gen_server.try_handle_call/4
        (stdlib 3.14) gen_server.erl:744: :gen_server.handle_msg/6
        (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3

Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
"""
