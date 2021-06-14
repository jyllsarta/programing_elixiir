defmodule Sequence.Stack.Server do
  use GenServer
  def init(items) do
    {:ok, items}
  end
  def handle_call(:pop, _from, items) do
    [ head | tail ] = items
    {:reply, head, tail}
  end
end

"""
iex(1)> {:ok, pid} = GenServer.start_link(Sequence.Stack.Server, [100, 4, 5])
{:ok, #PID<0.162.0>}
iex(2)> GenServer.call(pid, :pop)
100
iex(3)> GenServer.call(pid, :pop)
4
iex(4)> GenServer.call(pid, :pop)
5
iex(5)> GenServer.call(pid, :pop)

22:50:37.226 [error] GenServer #PID<0.162.0> terminating
** (MatchError) no match of right hand side value: []
    (sequence 0.1.0) lib/stack/server.ex:7: Sequence.Stack.Server.handle_call/3
    (stdlib 3.14) gen_server.erl:715: :gen_server.try_handle_call/4
    (stdlib 3.14) gen_server.erl:744: :gen_server.handle_msg/6
    (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message (from #PID<0.160.0>): :pop
State: []
Client #PID<0.160.0> is alive

    (stdlib 3.14) gen.erl:208: :gen.do_call/4
    (elixir 1.11.3) lib/gen_server.ex:1024: GenServer.call/3
    (stdlib 3.14) erl_eval.erl:680: :erl_eval.do_apply/6
    (elixir 1.11.3) src/elixir.erl:280: :elixir.recur_eval/3
    (elixir 1.11.3) src/elixir.erl:265: :elixir.eval_forms/3
    (iex 1.11.3) lib/iex/evaluator.ex:261: IEx.Evaluator.handle_eval/5
    (iex 1.11.3) lib/iex/evaluator.ex:242: IEx.Evaluator.do_eval/3
    (iex 1.11.3) lib/iex/evaluator.ex:220: IEx.Evaluator.eval/3
** (EXIT from #PID<0.160.0>) shell process exited with reason: an exception was raised:
    ** (MatchError) no match of right hand side value: []
        (sequence 0.1.0) lib/stack/server.ex:7: Sequence.Stack.Server.handle_call/3
        (stdlib 3.14) gen_server.erl:715: :gen_server.try_handle_call/4
        (stdlib 3.14) gen_server.erl:744: :gen_server.handle_msg/6
        (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3

Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
"""
