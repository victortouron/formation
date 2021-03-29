defmodule Server.Router do
  use Plug.Router

  plug Plug.Static, from: "lib/mixproject/priv/static/", at: "/static"

  plug :match
  plug :dispatch

  def check_is_nil(list, conn) do
    if List.first(list) != nil do
    send_resp(conn, 200, "succes")
    else
      send_resp(conn, 404, "error")
    end
  end

  get "/create" do
    %{"table" => table, "key"=> key, "value" => value} = Plug.Conn.Query.decode(conn.query_string)
    res = Server.Database.create(String.to_atom(table), {key, value})
    send_resp(conn, 200, Atom.to_string(res))
  end

  get "/update" do
    %{"table" => table, "key"=> key, "value" => value} = Plug.Conn.Query.decode(conn.query_string)
    res = Server.Database.update(String.to_atom(table), {key, value})
    send_resp(conn, 200, Atom.to_string(res))
  end

  get "/delete" do
    %{"table" => table, "key"=> key} = Plug.Conn.Query.decode(conn.query_string)
    res = Server.Database.delete(String.to_atom(table), String.to_atom(key))
    send_resp(conn, 200, Atom.to_string(res))
  end

  get "/read" do
    %{"table" => table, "key"=> key} = Plug.Conn.Query.decode(conn.query_string)
    reply = Server.Database.read(String.to_atom(table), key)
    # [{order_name, map}] = reply
    check_is_nil(reply, conn)
  end

  get "/search" do
    %{"id" => id, "value"=> key} = Plug.Conn.Query.decode(conn.query_string)
    reply = Server.Database.search(:json, [{id, key}])
    # [{order_name, map}] = reply
    check_is_nil(reply, conn)
  end

  get "/api/orders" do
    json = Poison.encode!(Enum.map(Server.Database.get_table(), fn {_key, map} -> map end))
    send_resp(conn, 200, json)
  end

  get "/api/order/:order_id" do
    [{_id, map}] = Server.Database.read(:json, "nat_order" <> order_id)
    send_resp(conn, 200, Poison.encode!(map))
  end

  get _, do: send_file(conn, 200, "lib/mixproject/priv/static/index.html")

end

  #
  # defmodule Server.Router do
  #   use Server.TheCreator
  #     my_error code: 404, content: "Custom error message"
  #     my_get "/" do
  #       {200, "Welcome to the new world of Plugs!"}
  #     end
  #     my_get "/me" do
  #       {200, "You are the Second One."}
  #     end
  #   end
