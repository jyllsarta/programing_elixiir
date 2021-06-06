defmodule Spawner do
  def echo_and_die(sender, msg) do
    IO.puts("[spawner] echo_and_die_start, sending #{msg} to: #{sender |> inspect}")
    send sender, msg
    IO.puts("[spawner] echo_and_die_end, sent #{msg}")
  end  
end

defmodule Waiter do
  def wait_response(generation) do
    IO.puts("[waiter on #{self() |> inspect} / #{generation}] waiting response on waiter module")
    receive do
      msg ->
        IO.puts("[waiter on #{self() |> inspect} / #{generation}] message coming! #{msg}")
        wait_response(generation + 1)
    end  
  end  
end

IO.puts("[main process] start session.")
waiter = spawn_link(Waiter, :wait_response, [0])
IO.puts("[main process] waiter spawned.")
spawn_link(Spawner, :echo_and_die, [self(), "<this is to_self>"])
spawn_link(Spawner, :echo_and_die, [waiter, "<this is to_waiter>"])
IO.puts("[main process] spawner spawned.")
IO.puts("[main process] start sleep 500ms, I am ... #{self() |> inspect}")
:timer.sleep(500)
IO.puts("[main process] sleep end, waiting response on top level, I am ... #{self() |> inspect}")
Waiter.wait_response(0)


# 何を受信するか、 調査してほしい。 子プロセスが終了するとき、 子プロセスからの通知を待っていないことが問題になるだろうか？

"""
  [ifrita] ~/programming_elixiir/work/15 % iex 15-3-1.exs
  Erlang/OTP 24 [erts-12.0.1] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

  [main process] start session.
  [main process] waiter spawned.
  [main process] spawner spawned.
  [spawner] echo_and_die_start, sending <this is to_waiter> to: #PID<0.112.0>
  [spawner] echo_and_die_start, sending <this is to_self> to: #PID<0.105.0>
  [main process] start sleep 500ms, I am ... #PID<0.105.0>
  [spawner] echo_and_die_end, sent <this is to_waiter>
  [spawner] echo_and_die_end, sent <this is to_self>
  [waiter on #PID<0.112.0> / 0] waiting response on waiter module
  [waiter on #PID<0.112.0> / 0] message coming! <this is to_waiter>
  [waiter on #PID<0.112.0> / 1] waiting response on waiter module
  [main process] sleep end, waiting response on top level, I am ... #PID<0.105.0>
  [waiter on #PID<0.105.0> / 0] waiting response on waiter module
  [waiter on #PID<0.105.0> / 0] message coming! <this is to_self>
  [waiter on #PID<0.105.0> / 1] waiting response on waiter module
"""

# (予想とは違った)問題にならなかったね？ 500ms後にreceiveしようとしはじめてもメッセージを漏らすことなく報告することができた
# なんだろう、受信待ちみたいな感じでsenderがのんびりしてるのか、receiverの方のポストに投函されてるのかいずれかのモデルなんだろうけどあとに続く問題的に前者なんだろうなあ
