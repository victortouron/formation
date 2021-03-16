defmodule Server.Router do
  use Plug.Router

  plug :match
  plug :dispatch


  get "/read" do
    query_string = conn.query_string
    query_params = Plug.Conn.Query.decode(query_string)
    IO.inspect query_params
    db = Map.fetch(query_params, "id")
    key = Map.fetch(query_params, "value")
    IO.inspect db
    IO.inspect key
    send_resp(conn, 200, "Read")
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
