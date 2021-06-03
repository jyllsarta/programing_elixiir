defmodule Chain do
  def counter(next_pid) do
    receive do
      n ->
      send next_pid, n + 1
    end
  end

  def create_processes(n) do
    code_to_run = fn (_,send_to) ->
      spawn(Chain, :counter, [send_to])
    end
    last = Enum.reduce(1..n, self(), code_to_run)
    send(last, 0) #最後に作ったプロセスへ 0 を送り、 カウントを開始
    receive do #結果が戻ってくるまで待つ
      final_answer when is_integer(final_answer) ->
      "Result is #{inspect(final_answer)}"
    end
  end
  def run(n) do
    :timer.tc(Chain, :create_processes, [n])
    |> IO.inspect
  end
end

# [ifrita] ~/programming_elixiir/work/15 % elixir --erl "+P 1000000" -r 15-1-1.exs -e "Chain.run(400_000)"
# {1899326, "Result is 400000"}
# [ifrita] ~/programming_elixiir/work/15 % elixir --erl "+P 1000000" -r 15-1-1.exs -e "Chain.run(1_000_000)"
# {4445202, "Result is 1000000"}

# そのとおり！