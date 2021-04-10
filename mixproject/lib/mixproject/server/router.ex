defmodule Server.Router do
  use Plug.Router
  require EEx
  EEx.function_from_file :defp, :layout, "web/layout.html.eex", [:render]
  # plug Plug.Static, from: "/home/coachbombay/formation/mixproject/priv/static", at: "/static"

  plug Plug.Static, at: "/public", from: :mixproject


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

  get "/api/vtouron_orders_index" do
    qs =  conn.query_string
    query = String.replace(qs, "=", ":")
    {_res,{{_,_code, _message},_headers,body}} = Riak.search("vtouron_orders_index", query)
    send_resp(conn, 200, body)
  end

  get "/api/orders" do
    if conn.query_string == "" do
      page = 1
      {_res,{{_,_code, _message},_headers,body}} = Riak.search("vtouron_orders_index", "type:nat_order", page)
      send_resp(conn, 200, body)
    else
      %{"page" => page} = Plug.Conn.Query.decode(conn.query_string)
      {_res,{{_,_code, _message},_headers,body}} = Riak.search("vtouron_orders_index", "type:nat_order", String.to_integer(page))
      send_resp(conn, 200, body)
    end
  end

  get "/api/order/:order_id" do
    {_res,{{_,_code, _message},_headers,body}} = Riak.search("vtouron_orders_index", "id:nat_order" <> order_id)
    send_resp(conn, 200, body)
  end

  post "/api/delete" do
    {:ok, data, _conn} = read_body(conn)
    {:ok, res} = Poison.decode(data)
    {_key, value} = List.first(Map.to_list(res))
    body = Poison.encode!("Delete")
    Riak.delete_object("vtouron_orders", value)
    :timer.sleep(2000)
    send_resp(conn, 200, body)
  end

  # get _, do: send_file(conn, 200, "/home/coachbombay/formation/mixproject/priv/static/index.html")
  get _ do
  conn = fetch_query_params(conn)
  render = Reaxt.render!(:app, %{path: conn.request_path, cookies: conn.cookies, query: conn.params},30_000)
  send_resp(put_resp_header(conn,"content-type","text/html;charset=utf-8"), render.param || 200,layout(render))
  end

end
