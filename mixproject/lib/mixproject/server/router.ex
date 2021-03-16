defmodule Server.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/create" do
    %{"table" => table, "key"=> key, "value" => value} = Plug.Conn.Query.decode(conn.query_string)
    IO.inspect Server.Database.create(String.to_atom(table), {String.to_atom(key), value})
    send_resp(conn, 200, "ok")
  end

  get "/read" do
    %{"table" => table, "key"=> key} = Plug.Conn.Query.decode(conn.query_string)
    reply = Server.Database.read(String.to_atom(table), String.to_atom(key))
    {rep, res} =  Keyword.fetch(reply, String.to_atom(key))
    send_resp(conn, 200, res)
  end

  get "/", do: send_resp(conn, 200, "Welcome")
  match _, do: send_resp(conn, 404, "Page Not Found")
end


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
