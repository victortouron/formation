defmodule Fsm.Server do
  use GenServer

    @impl true
    def init(order_id) do
      order = Riak.get_object("vtouron_orders", "nat_order" <> order_id)
      order_map = Poison.decode!order
      {:ok, order_map}
    end

    @impl true
    def handle_call(:process_payment, _form, order) do
      map_order = ExFSM.Machine.event(order, {:process_payment, []})
      res = case map_order do
        {:next_state, {old_state, updated_order}}  ->
          id = Map.get(order, "id")
          Riak.put_object("vtouron_orders", id, updated_order)
          updated_order
          # {:reply, old_state, updated_order}
        {:error, :illegal_action}  ->
          order
          # {:reply, :error, :illegal_action}
      end
      {:reply, res, order}
    end

end
