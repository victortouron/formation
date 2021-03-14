defmodule Server.Supervisor do
  use Supervisor

  def init(init_value) do
    Supervisor.init(Server.Database, init_value)
  end

  def start_link(_opts) do
    IO.puts "Supervisor Start Link"
    children = [
      Server.Database
    ]
    opts = [
      strategy: :one_for_one
    ]
    Supervisor.start_link(children, opts)
  end
end
