defmodule Server.Game.Supervisor.Supervisor do
  use DynamicSupervisor
  alias Server.Game.Server.{Server, GamesServer}
  require Logger

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    init_lobby()
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def init_lobby() do
    child_spec = {
      GamesServer,
      "lobby"
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def start_game(args) do
    child_spec = {
      Server,
      args
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
