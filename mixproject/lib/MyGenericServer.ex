defmodule MyGenericServer do
  def start_link(callback_module, server_initial_state) do
    process_pid = spawn_link(fn -> loop({callback_module, server_initial_state}) end)
    {:ok, process_pid}
  end
  def cast(process_pid, request), do: send(process_pid, {:cast, request})
  def call(process_pid, request) do
    send(process_pid, {:call, self(), request})
    receive do
    {:response, response} ->
    response
    end
  end
  def loop({callback_module, server_state}) do
    receive do
      {:cast, {tag, amount}} ->
        {:noreply, new_amount} = callback_module.handle_cast({tag, amount}, server_state)
        loop({callback_module, new_amount})
      {:call, pid, tag} ->
        {response, response} = callback_module.handle_call(tag, server_state)
        send(pid, {:response, response})
        loop({callback_module, server_state})
      end
    end
  end
