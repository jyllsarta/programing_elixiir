defmodule Ticker do
  @interval 2000
  @name :ticker
  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end 

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def generator(clients) do
    receive do
      {:register, pid} ->
      IO.puts "registering #{inspect pid}"
      generator([pid|clients])
    after
      @interval ->
        IO.puts "tick"
        if Enum.count(clients) > 0 do
          [ head | tail ] = clients 
          send head, {:tick}
          generator(tail ++ [head])
        else 
          IO.puts("no clients")
          generator(clients)
        end
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])  
    Ticker.register(pid)  
  end  
  def receiver do  
    receive do  
      {:tick} ->  
        IO.puts "tock in client"  
        receiver()  
    end  
  end  
end

# 中間サーバを導入するとき、 「およそ 2秒に一度」 の通知と書いた。 しかし、 Tick.  generator関数の receive の繰り返しでは、 明示的に 2,000 ミリ秒のタイムアウトを  設定している。 時間は完全に正確であるようにみえるのに、 なぜ 「およそ」 と書いたかわ  かるだろうか。 

# これは送る側のタイミングと受け取る側のタイミングが同期していないから。送ったつもりでももらった方が受け取るつもりなかったら無視されるので、それ