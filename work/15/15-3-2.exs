defmodule Spawner do
  def echo_and_die(sender, msg) do
    IO.puts("[spawner] echo_and_die_start, sending #{msg} to: #{sender |> inspect}")
    send sender, msg
    IO.puts("[spawner] echo_and_die_end, sent #{msg}, and I will explode")
    raise "boom"
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


# 同じように、 しかし子プロセスが終了の代わりに例外を発生するようにしてみよう。 何か  出力に違いはあるだろうか。

"""
[main process] start session.
[main process] waiter spawned.
[main process] spawner spawned.
[spawner] echo_and_die_start, sending <this is to_self> to: #PID<0.105.0>
[spawner] echo_and_die_start, sending <this is to_waiter> to: #PID<0.112.0>
[main process] start sleep 500ms, I am ... #PID<0.105.0>
[spawner] echo_and_die_end, sent <this is to_self>, and I will explode
[spawner] echo_and_die_end, sent <this is to_waiter>, and I will explode
[waiter on #PID<0.112.0> / 0] waiting response on waiter module
[waiter on #PID<0.112.0> / 0] message coming! <this is to_waiter>
[waiter on #PID<0.112.0> / 1] waiting response on waiter module
** (EXIT from #PID<0.105.0>) an exception was raised:
    ** (RuntimeError) boom
        15-3-2.exs:6: Spawner.echo_and_die/2
"""

# 死んだ