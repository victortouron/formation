defmodule Fsm.Server do
  use GenServer

    @impl true
    def init(order_id) do
      order = Riak.get_object("vtouron_orders", "nat_order" <> order_id)
      order_map = Poison.decode!order
      {:ok, order_map}
    end

    @impl true
    def handle_call(:payment_process, _form, order) do
      map_order = ExFSM.Machine.event(order, {:payment_process, []})
      case map_order do
        {:next_state, {old_state, updated_order}}  ->
          id = Map.get(order, "id")
          Riak.put_object("vtouron_orders", id, updated_order)
          {:reply, old_state, updated_order}
        {:error, :illegal_action}  ->
          {:reply, :error, :illegal_action}
      end
    end

end
