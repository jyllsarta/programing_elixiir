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
        IO.puts("[waiter on #{self() |> inspect} / #{generation}] message coming! #{msg |> inspect}")
        wait_response(generation + 1)
    end  
  end  
end

IO.puts("[main process] start session.")
waiter = spawn_link(Waiter, :wait_response, [0])
IO.puts("[main process] waiter spawned.")
spawn_monitor(Spawner, :echo_and_die, [self(), "<this is to_self>"])
spawn_monitor(Spawner, :echo_and_die, [waiter, "<this is to_waiter>"])
IO.puts("[main process] spawner spawned.")
IO.puts("[main process] start sleep 500ms, I am ... #{self() |> inspect}")
:timer.sleep(500)
IO.puts("[main process] sleep end, waiting response on top level, I am ... #{self() |> inspect}")
Waiter.wait_response(0)


# 同じように、 しかし子プロセスが終了の代わりに例外を発生するようにしてみよう。 何か  出力に違いはあるだろうか。

"""
[ifrita] ~/programming_elixiir/work/15 % iex 15-3-3.exs
Erlang/OTP 24 [erts-12.0.1] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

[main process] start session.
[main process] waiter spawned.
[main process] spawner spawned.
[spawner] echo_and_die_start, sending <this is to_self> to: #PID<0.105.0>
[spawner] echo_and_die_start, sending <this is to_waiter> to: #PID<0.112.0>
[main process] start sleep 500ms, I am ... #PID<0.105.0>
[spawner] echo_and_die_end, sent <this is to_self>, and I will explode
[spawner] echo_and_die_end, sent <this is to_waiter>, and I will explode
[waiter on #PID<0.112.0> / 0] waiting response on waiter module
[waiter on #PID<0.112.0> / 0] message coming! "<this is to_waiter>"
[waiter on #PID<0.112.0> / 1] waiting response on waiter module

17:34:44.940 [error] Process #PID<0.113.0> raised an exception
** (RuntimeError) boom
    15-3-3.exs:6: Spawner.echo_and_die/2

17:34:44.940 [error] Process #PID<0.114.0> raised an exception
** (RuntimeError) boom
    15-3-3.exs:6: Spawner.echo_and_die/2
[main process] sleep end, waiting response on top level, I am ... #PID<0.105.0>
[waiter on #PID<0.105.0> / 0] waiting response on waiter module
[waiter on #PID<0.105.0> / 0] message coming! "<this is to_self>"
[waiter on #PID<0.105.0> / 1] waiting response on waiter module
[waiter on #PID<0.105.0> / 1] message coming! {:DOWN, #Reference<0.2089310015.1313603593.109367>, :process, #PID<0.113.0>, {%RuntimeError{message: "boom"}, [{Spawner, :echo_and_die, 2, [file: '15-3-3.exs', line: 6]}]}}
[waiter on #PID<0.105.0> / 2] waiting response on waiter module
[waiter on #PID<0.105.0> / 2] message coming! {:DOWN, #Reference<0.2089310015.1313603593.109368>, :process, #PID<0.114.0>, {%RuntimeError{message: "boom"}, [{Spawner, :echo_and_die, 2, [file: '15-3-3.exs', line: 6]}]}}
[waiter on #PID<0.105.0> / 3] waiting response on waiter module
"""

# うわなるほど

# mainがspawner1とspawner2のメールを購読開始
# mainくん500msの睡眠開始
# spawner1, 2それぞれが、waiter, main両方にメッセージを送信(waiterに正規メール1通到着)(mainに正規メール1通到着)
# waiterくんメール受信したので正規メールの読み上げ (一応次のメール待機開始)
# waiter側に送ったspwaner1死ぬ(mainにdownメール1通到着)
# waiter側に送ったspwaner2死ぬ(mainにdownメール1通到着)
# Elixirのシステム的にモニター先が死んだことを検知、そのことを画面出力
# mainくん500msの睡眠から目覚める、メッセージの開封開始
# 一番最初のspawner1くんが送った正規メールの読み上げ
# downメール1の読み上げ
# downメール2の読み上げ
# --- 終了 ---

