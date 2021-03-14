defmodule JsonLoader do
  def load_to_database(database, json_file) do
    {:ok, file_content} = File.read(json_file)
    {:ok, map} = Poison.decode(file_content)
    Enum.reduce(map, [], fn x, _acc ->
      Server.Database.create(database, {Map.get(x, "id"), Map.get(x, "custom")})
    end)
    # {:ok}
  end
end
