defmodule HelloPort do
  use GenServer

  def call(route), do: GenServer.call(Hello, route)
  def cast({route, value}), do: GenServer.cast(Hello, {route, value})
  def handle_info({port,{:exit_status,0}},port), do: {:stop,:normal,port}
  def handle_info({port,{:exit_status,_}},port), do: {:stop,:port_terminated,port}
  def handle_info(_,port), do: {:noreply,port}
  def handle_cast(term,port) do
    send(port,{self,{:command,:erlang.term_to_binary(term)}})
    {:noreply,port}
  end
  def handle_call(term,_reply_to,port) do
    send(port,{self,{:command,:erlang.term_to_binary(term)}})
    res = receive do {^port,{:data,b}}->:erlang.binary_to_term(b) end
    {:reply,res,port}
  end

  def start_link(initial_value) do
    IO.puts "Hello Port Start Link"
    {:ok, _pid} = GenServer.start_link(HelloPort, {"node hello.js", 0, cd: "/home/coachbombay/formation/hello_port/lib/web"}, name: Hello)
  end

  def init({cmd,init,opts}) do
    IO.inspect cmd
    IO.inspect opts
    port = Port.open({:spawn, '#{cmd}'}, [:binary, :exit_status, packet: 4] ++ opts)
    send(port,{self,{:command,:erlang.term_to_binary(init)}})
    {:ok, port}
  end
end
