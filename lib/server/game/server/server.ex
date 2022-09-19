defmodule Server.Game.Server.Server do
  use GenServer, restart: :transient
  require Logger

  def start_link(args) do
    id = Map.get(args, "id")
    Logger.info("starting genserver #{id}")
    GenServer.start_link(__MODULE__, args, name: via_tuple(id))
  end

  def get_details(process_name) do
    server = process_name |> via_tuple() |> GenServer.whereis()

    if server != nil do
      server |> GenServer.call(:get)
    end
  end

  def stop(process_name) do
    Logger.info("stopping #{process_name}")
    # Given the :transient option in the child spec, the GenServer will restart
    # if any reason other than `:normal` is given.
    process_name |> via_tuple() |> GenServer.call(:stop)
  end

  @impl true
  def init(args) do
    Logger.info("Starting process #{inspect(args)}")
    state = State.new(args)
    Logger.info("Room created #{inspect(state)}")
    {:ok, state}
  end

  defp via_tuple(name),
    do: {:via, Registry, {GameServer.GameRegistry, name}}
end
