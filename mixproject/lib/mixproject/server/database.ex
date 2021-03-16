defmodule Server.Database do
  use GenServer
  def create(database, {key, value}), do: GenServer.cast(Server.Database, {:create, database, {key, value}})
  def read(database, key) do
    GenServer.call(Server.Database, {database, key})
  end
  def update(database, {key, value}), do: GenServer.cast(Server.Database, {:update, database, {key, value}})
  def delete(database, key), do: GenServer.cast(Server.Database, {:delete, database, key})

  def handle_call({database, key}, _pid, intern_state) do
     {:reply, :ets.lookup(database, key), intern_state}
   end
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


  def search(database, criteria) do
    list = :ets.tab2list(database)
    response = Enum.reduce(criteria, [], fn x, acc ->
      id = elem(x, 0)
      key = elem(x, 1)
      match = Enum.reduce(list, [], fn x, acc ->
        order = Enum.reduce(Tuple.to_list(x), [], fn x, _acc ->
          if is_map(x) == true do
            if Map.get(x, id) == key, do: _acc = x
          end
        end)
        if order != nil do
            _acc = order
        else
          acc
        end
      end)
      acc ++ [match]
    end)
    {:ok, response}
  end


  def start_link(initial_value) do
    IO.puts "Server Database Start Link"
    {:ok, _pid} = GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def init(_) do
    db = :user
    :ets.new(db, [:named_table, :public])
    Server.Database.create(db, {:name, "Vic"})
    {:ok, :ok}
  end
end
