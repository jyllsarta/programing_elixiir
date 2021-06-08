defmodule FibSolver do
  def fib(scheduler) do
    send scheduler, {:ready, self()}
    receive do
      {:fib, n, client} ->
        send client, {:answer, n, fib_calc(n), self()}
        fib(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end
  #意図的に、 とても非効率にしている
  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n-1) + fib_calc(n-2)
end 

defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
      |> Enum.map(fn(_) -> spawn(module, func, [self()]) end)
      |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [next | tail] = queue
        send pid, {:fib, next, self()}
        schedule_processes(processes, tail, results)
      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1,_}, {n2,_} -> n1 <= n2 end)
        end
      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end
end 

to_process = List.duplicate(40, 20)
Enum.each 1..10, fn num_processes ->
  {time, result} = :timer.tc(
    Scheduler, :run, [num_processes, FibSolver, :fib, to_process]
  )
if num_processes == 1 do
  IO.puts inspect result
  IO.puts "\n #time (s)"
end
  :io.format "~2B ~.2f~n", [num_processes, time/1000000.0]
end 

"""
[localhost] ~/programming_elixiir/work/15 % iex 15-5-1.exs
Erlang/OTP 23 [erts-11.1.8] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe] [dtrace]

warning: do not use "length(queue) > 0" to check if a list is not empty since length always traverses the whole list. Prefer to pattern match on a non-empty list, such as [_ | _], or use "queue != []" as a guard
  15-5-1.exs:27

[{37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}]

 #time (s)
 1 13.96
 2 7.22
 3 5.29
 4 4.15
 5 3.82
 6 4.50
 7 4.12
 8 4.94
 9 5.77
10 4.97
"""

# 4並列以降は誤差って感じ？
# 2.9GHz 6コアIntel Core i9（Turbo Boost使用時最大4.8GHz）、12MB共有L3キャッシュ なのでなんか違いそうだけど、6の時の性能が良くねえ
# CPU利用率は　10% 18%  26% 34% 42% 55% 64% 76% 83% 
# ... 並列数足りてねえ！ 生成時のコストの方が高いって感じになっちゃってますね、20にしてみよ

"""
[localhost] ~/programming_elixiir/work/15 % iex 15-5-1.exs
Erlang/OTP 23 [erts-11.1.8] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe] [dtrace]

warning: do not use "length(queue) > 0" to check if a list is not empty since length always traverses the whole list. Prefer to pattern match on a non-empty list, such as [_ | _], or use "queue != []" as a guard
  15-5-1.exs:27

[{40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}, {40, 102334155}]

 #time (s)
 1 60.07
 2 31.52
 3 24.77
 4 18.69
 5 15.69
 6 15.80
 7 14.26
 8 15.23
 9 16.05
10 15.14
"""

# 40でも4コア付近でサチるじゃん、どういうこと？これはmac側がなんかしてそうで、よくわかりませんね