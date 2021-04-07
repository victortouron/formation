defmodule HelloPort do
  use GenServer

  def start_link(initial_value) do
    IO.puts "Hello Port Start Link"
    {:ok, _pid} = GenServer.start_link(HelloPort, {"node hello.js", 0, cd: "/home/coachbombay/formation/mixproject/lib/mixproject/priv/static/bundle.js"}, name: Hello)
  end

  def init(_) do
    port = Port.open({:spawn, '#{cmd}'}, [:binary, :exit_status, packet: 4] ++ opts)
    {:ok, :ok}
  end
end
