defmodule JsonLoader do
  def load_to_database(database, json_file) do
    {:ok, file_content} = File.read(json_file)
    {:ok, map} = Poison.decode(file_content)
    Enum.reduce(map, [], fn x, _acc ->
      Server.Database.create(database, {Map.get(x, "id"), x})
    end)
  end

  def load_to_Riak(json_file) do
    {:ok, file_content} = File.read(json_file)
    {:ok, map} = Poison.decode(file_content)
    stream = Task.async_stream(map, fn order ->
      Riak.put_object("vtouron_orders", Map.get(order, "id"), order)
    end, [max_concurrency: 10, timeout: 100000])
    Stream.run(stream)
  end
end
