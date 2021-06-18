defmodule Sequence.Stack.Stash do
  use GenServer
  @me __MODULE__
  def start_link(items) do
    GenServer.start_link(__MODULE__, items, name: @me)
  end

  def get() do
    GenServer.call(@me, {:get})
  end

  def update(items) do
    GenServer.cast(@me, {:update, items})
  end

  # サーバの実装
  def init(items) do
    {:ok, items}
  end

  def handle_call({:get}, _from, items) do
    {:reply, items, items}
  end

  def handle_cast( {:update, items}, _current_items) do
    {:noreply, items}
  end
end
