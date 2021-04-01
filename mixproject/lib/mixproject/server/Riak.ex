defmodule Riak do
  def url, do: "https://kbrw-sb-tutoex-riak-gateway.kbrw.fr"

  def auth_header do
    username = "sophomore"
    password = "jlessthan3tutoex"
    auth = :base64.encode_to_string("#{username}:#{password}")
    [{'authorization', 'Basic #{auth}'}]
  end
  
  def get_buckets do
    {:ok,{{_,200, message},headers,body}} = :httpc.request(:get,{'#{Riak.url}/buckets?buckets=true', Riak.auth_header()},[],[])
    body
  end
  def get_key(bucket) do
    {:ok,{{_,200, message},headers,body}} = :httpc.request(:get,{'#{Riak.url}/buckets/#{bucket}/keys?keys=true', Riak.auth_header()},[],[])
    body
  end
  def get_object(bucket, key) do
    {:ok,{{_,200, message},headers,body}} = :httpc.request(:get,{'#{Riak.url}/buckets/#{bucket}/keys/#{key}', Riak.auth_header()},[],[])
    body
  end
  def put_object(bucket, key, object) do
    body = Poison.encode!(object)
    {:ok, resp} = :httpc.request(:put,{'#{Riak.url}/buckets/#{bucket}/keys/#{key}', Riak.auth_header(), 'application/json', body},[],[])
  end
  def delete_object(bucket, key) do
    {:ok, res} = :httpc.request(:delete,{'#{Riak.url}/buckets/#{bucket}/keys/#{key}', Riak.auth_header()},[],[])
  end
end
