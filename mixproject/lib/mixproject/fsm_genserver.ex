defmodule Fsm.Server do
  use GenServer

    @impl true
    def init(order_id) do
      order = Riak.get_object("vtouron_orders", "nat_order000147696")
      order_map = Poison.decode!order
      {:ok, order_map}
    end
    def start_link(order_id) do
      IO.puts "FSM Server Start Link"
      {:ok, _pid} = GenServer.start_link(__MODULE__, order_id, name: __MODULE__)
    end
end
