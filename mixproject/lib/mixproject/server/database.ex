defmodule Server.Database do
  use GenServer
  def create(database, {key, value}) do
    GenServer.cast(Server.Database, {:create, database, {key, value}})
    
  end
  def read(database, key), do: GenServer.call(Server.Database, {database, key})
  def update(database, {key, value}), do: GenServer.cast(Server.Database, {:update, database, {key, value}})
  def delete(database, key), do: GenServer.cast(Server.Database, {:delete, database, key})

  def handle_call({database, key}, _pid, intern_state), do: {:reply, :ets.lookup(database, key), intern_state}
  def handle_cast({:create, database, {key, value}}, intern_state) do
    :ets.insert_new(database, {key, value})
    {:noreply, intern_state}
  end
  def handle_cast({:update, database, {key, value}}, intern_state) do
    :ets.insert(database, {key, value})
    {:noreply, intern_state}
  end
  def handle_cast({:delete, database, key}, intern_state) do
    :ets.delete(database, key)
    {:noreply, intern_state}
  end

  def start_link(initial_value) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def init(_) do
    :ets.new(:pokedex, [:named_table, :public])
    {:ok, :ok}
  end
end
