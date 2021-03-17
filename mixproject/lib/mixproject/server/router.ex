# defmodule Server.Router do
#   use Plug.Router
#
#   plug :match
#   plug :dispatch
#
#   get "/create" do
#     %{"table" => table, "key"=> key, "value" => value} = Plug.Conn.Query.decode(conn.query_string)
#     res = Server.Database.create(String.to_atom(table), {String.to_atom(key), value})
#     send_resp(conn, 200, Atom.to_string(res))
#   end
#
#   get "/update" do
#     %{"table" => table, "key"=> key, "value" => value} = Plug.Conn.Query.decode(conn.query_string)
#     res = Server.Database.update(String.to_atom(table), {String.to_atom(key), value})
#     send_resp(conn, 200, Atom.to_string(res))
#   end
#
#   get "/delete" do
#     %{"table" => table, "key"=> key} = Plug.Conn.Query.decode(conn.query_string)
#     res = Server.Database.delete(String.to_atom(table), String.to_atom(key))
#     send_resp(conn, 200, Atom.to_string(res))
#   end
#
#   get "/read" do
#     %{"table" => table, "key"=> key} = Plug.Conn.Query.decode(conn.query_string)
#     reply = Server.Database.read(String.to_atom(table), String.to_atom(key))
#     {rep, res} =  Keyword.fetch(reply, String.to_atom(key))
#     send_resp(conn, 200, res)
#   end
#
#   get "/search" do
#     %{"id" => id, "value"=> key} = Plug.Conn.Query.decode(conn.query_string)
#     reply = Server.Database.search(:user, [{id, key}])
#     {rep, res} = Keyword.fetch(reply, String.to_atom(id))
#     send_resp(conn, 200, res)
#   end
#
#   get "/", do: send_resp(conn, 200, "Welcome")
#   match _, do: send_resp(conn, 404, "Page Not Found")
# end


  defmodule Server.Router do
    use Server.TheCreator
      my_error code: 404, content: "Custom error message"
      my_get "/" do
        {200, "Welcome to the new world of Plugs!"}
      end
      my_get "/me" do
        {200, "You are the Second One."}
      end
    end
