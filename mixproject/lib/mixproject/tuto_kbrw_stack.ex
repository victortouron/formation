db = :pokedex
:ets.new(db, [:named_table, :public])

Server.Supervisor.start_link(db)

Server.Database.create(db, {:pokemon, "carapuce"})
Server.Database.create(db, {:dresseur, "pierre"})
IO.inspect Server.Database.read(db, :pokemon)
IO.inspect Server.Database.read(db, :dresseur)
Server.Database.update(db, {:pokemon, "bulbizarre"})
Server.Database.update(db, {:dresseur, "sacha"})
IO.inspect Server.Database.read(db, :pokemon)
IO.inspect Server.Database.read(db, :dresseur)
Server.Database.delete(db, :pokemon)
Server.Database.delete(db, :dresseur)
IO.inspect Server.Database.read(db, :pokemon)
IO.inspect Server.Database.read(db, :dresseur)

db = :json
:ets.new(db, [:named_table, :public])
IO.puts "Loading JSON into DB"
JsonLoader.load_to_database(db, "/home/coachbombay/formation/mixproject/orders_dump/orders_chunk0.json")
IO.puts "JSON Loaded Succes"

{:ok, msg} = Server.Database.search(db, [{"order_number", "000147785"}, {"order_number", "000147784"}, {"order_number", "000147814"}])
IO.inspect msg
