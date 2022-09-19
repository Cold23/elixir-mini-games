defmodule Server.Game.Server.GamesServer do
  use GenServer, restart: :transient
  alias Server.Game.Server.State.ActiveGames
  require Logger

  def init(_args) do
    Logger.info("Starting server containing currentGamesInfo")
    {:ok, ActiveGames.new()}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def new_room() do
    "lobby" |> via_tuple() |> GenServer.call(:add_room)
  end

  @impl true
  def handle_call(:add_room, _from, state) do
    room = ActiveGames.check_if_room_exist(state)

    case room.players do
      1 ->
        newState = ActiveGames.update_room(%{players: 2, id: room.id}, state)
        {:reply, %{status: :joined, id: room.id}, newState}

      _ ->
        {id, state} = ActiveGames.get_id(state)
        newState = ActiveGames.add_room(%{players: 1, id: id}, state)
        {:reply, %{status: :created, id: id}, newState}
    end
  end

  defp via_tuple(name),
    do: {:via, Registry, {Server.GameRegistry, name}}
end
