defmodule ServerWeb.GameChannelController do
  use Phoenix.Channel
  require Logger

  # when someone joins
  def join("game", %{"id" => id}, socket) do
    # assing the user id to the socket
    res = Server.Game.Server.GamesServer.new_room()

    case res.status do
      :created ->
        Server.Game.Supervisor.Supervisor.start_game(%{game_id: res.id})

      :joined ->
        nil
    end

    Logger.info("joined game with id #{res.id} status #{res.status}")
    {:ok, %{game_id: res.id, status: res.status}, assign(socket, :user_id, id)}
  end

  # when someone leaves
  def terminate(_reason, socket) do
    Logger.info("Left")
  end
end
