defmodule Spawner do
  def echo do
    receive do
      {sender, msg} ->
      send sender, {:ok, msg}
    end
  end
end

defmodule Waiter do
  def wait_response do
    receive do
      {sender, msg} ->
      IO.inspect(msg)
      wait_response()
    end
  end
end


pid = spawn(Spawner, :echo, [])
pid2 = spawn(Spawner, :echo, [])
send pid, {self(), "fred!"}
send pid2, {self(), "betty!"}
Waiter.wait_response()


# •プロセスから戻ってくる返事の順序は理論的に決定的であるか？ 実際は？

# No
# プロセスの中で何が起こってるかわからない「外の世界」の話なので、内部的にランダムなsleepかますとかしたらもうわかんないし、そうしてるかどうかも呼び出し側から判断できない
# この例においてはほぼ確定で先に呼んだほうが先に返事するはずだけど、それはこの例においてはsendしてすぐ返事くるから順番入れ替わるほどの暇がないってだけ

# •もしその答えが 「No」 であるなら、 どうすれば順序を決定的にできるだろうか？

# await Promise.all する
# elixirでやるとすると、それこそアキュムレータを噛ませて全員からの返事が集まったら値を返す関数を作ればいいのでは
# すごい雑にやるとこんな感じかなあ
# def wait_response(items, 100      ,  item) do: IO.puts("全要素が集まりました！")
# def wait_response(items, num_items,  item) do: receive do {sender, msg} -> wait_response([items | item], Enum.length(items) + 1, msg) end
