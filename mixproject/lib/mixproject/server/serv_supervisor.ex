defmodule Server.Supervisor do
  use Supervisor
  # def start_link, do: {:ok, _} = Supervisor.start_link(__MODULE__, strategy: :one_for_one, name: __MODULE__)
  # def init(_) do
  # children = [
  #     Server.Database
  #   ]
  # Supervisor.init(children, strategy: :one_for_one)
  # JsonLoader.load_to_database(:pokedex, "/home/coachbombay/formation/mixproject/orders_dump/orders_chunk0.json")
  # end

  def init(init_value) do
    {:ok, init_value}
  end

  def start_link(_opts) do
    children = [Server.Database]
    opts = [strategy: :one_for_one]
    {:ok, pid} = Supervisor.start_link(children, opts)
    JsonLoader.load_to_database(:pokedex, "/home/coachbombay/formation/mixproject/orders_dump/orders_chunk0.json")
    {:ok, pid}
    # IO.inspect :ets.tab2list(:pokedex)
    #{:ok}
  end

end
