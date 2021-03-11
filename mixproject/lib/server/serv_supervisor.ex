defmodule Server.Supervisor do
  use Supervisor
  def start_link, do: {:ok, _} = Supervisor.start_link(__MODULE__, strategy: :one_for_one, name: __MODULE__)
  def init(_) do
  children = [
      Server.Database
    ]
  Supervisor.init(children, strategy: :one_for_one)
  end
end
