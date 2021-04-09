defmodule Mixproject do
  use Application

 @impl true
 def start(_type, _args) do
   # Although we don't use the supervisor name below directly,
   # it can be useful when debugging or introspecting the system.
   # Server.Supervisor.start_link()
   # Application.put_env(
   #    :reaxt,:global_config,
   #    Map.merge(
   #      Application.get_env(:reaxt,:global_config), %{localhost: "http://localhost:4001"}
   #    )
   #  )
   #  Reaxt.reload
 end
  @moduledoc """
  Documentation for `Mixproject`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mixproject.hello()
      :world

  """
  def hello do
    :world
  end
end
