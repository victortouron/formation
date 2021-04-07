defmodule Riak do
  def url, do: "https://kbrw-sb-tutoex-riak-gateway.kbrw.fr"

  def auth_header do
    username = "sophomore"
    password = "jlessthan3tutoex"
    auth = :base64.encode_to_string("#{username}:#{password}")
    [{'authorization', 'Basic #{auth}'}]
  end
  def get_buckets do
    {_res,{{_,200, _message},_headers,body}} = :httpc.request(:get,{'#{Riak.url}/buckets?buckets=true', Riak.auth_header()},[],[])
    body
  end
  def get_key(bucket) do
    {_res,{{_,200, _message},_headers,body}} = :httpc.request(:get,{'#{Riak.url}/buckets/#{bucket}/keys?keys=true', Riak.auth_header()},[],[])
    body
  end
  def get_object(bucket, key) do
    {_res,{{_,200, _message},_headers,body}} = :httpc.request(:get,{'#{Riak.url}/buckets/#{bucket}/keys/#{key}', Riak.auth_header()},[],[])
    body
  end
  def get_indexes() do
    {_res,{{_,200, _message},_headers,body}} = :httpc.request(:get,{'#{Riak.url}/search/index', Riak.auth_header()},[],[])
    body
  end
  def put_object(bucket, key, object) do
    body = Poison.encode!(object)
    {res,{{_,_code, _message},_headers,_body}} = :httpc.request(:put,{'#{Riak.url}/buckets/#{bucket}/keys/#{key}', Riak.auth_header(), 'application/json', body},[],[])
    res
  end
  def put_schema(name) do
    {:ok, schema} = File.read('/home/coachbombay/formation/mixproject/lib/mixproject/riak/order_shema0.xml')
    :httpc.request(:put,{'#{Riak.url}/search/schema/#{name}', Riak.auth_header(), 'application/xml', schema},[],[])
  end
  def delete_object(bucket, key) do
    {res,{{_,_code, _message},_headers,_body}} = :httpc.request(:delete,{'#{Riak.url}/buckets/#{bucket}/keys/#{key}', Riak.auth_header()},[],[])
    res
  end
  def delete_bucket(bucket) do
    :httpc.request(:delete,{'#{Riak.url}/buckets/#{bucket}/props', Riak.auth_header()},[],[])
  end
  def create_index(name, schema) do
    map = %{schema: "#{schema}"}
    json = Poison.encode!(map)
    :httpc.request(:put,{'#{Riak.url}/search/index/#{name}', Riak.auth_header(), 'application/json', json},[],[])
  end
  def empty_bucket(bucket) do
    keys = get_key(bucket)
    map = Poison.decode!(keys)
    orders = Map.get(map, "keys")
    Enum.map(orders, fn order ->
      delete_object(bucket, order)
    end)
  end
  def assign_index_to_bucket(bucket, index) do
    map = %{props: %{search_index: "#{index}"}}
    json = Poison.encode!(map)
    :httpc.request(:put,{'#{Riak.url}/buckets/#{bucket}/props', Riak.auth_header(), 'application/json', json},[],[])
  end
  def search(index, query, page \\ 1, rows \\ 30, sort \\ "creation_date_index") do
    start = rows * (page - 1);
    :httpc.request(:get,{'https://kbrw-sb-tutoex-riak-gateway.kbrw.fr/search/query/#{index}/?wt=json&sort=creation_date_index%20asc&start=#{start}&page=#{page}&rows=#{rows}&q=' ++ to_charlist(query), Riak.auth_header()},[],[])
  end

end
