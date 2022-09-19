defmodule Server.Game.Server.State.ActiveGames do
  defstruct [:rooms, :next_id]

  def new() do
    %__MODULE__{
      rooms: Arrays.new(),
      next_id: 0
    }
  end

  def update_room(payload, state) do
    state =
      update_in(state, [Access.key!(:rooms)], fn rooms ->
        Arrays.new(
          Enum.map(rooms, fn room ->
            if room.id == payload.id do
              Map.put(room, :players, payload.players)
            else
              room
            end
          end)
        )
      end)

    state
  end

  def check_if_room_exist(state) do
    room = state.rooms[-1]

    case room do
      nil ->
        %{id: -1, players: -1}

      %{"players" => 2} ->
        %{id: -1, players: -1}

      _ ->
        %{id: room.id, players: room.players}
    end
  end

  def add_room(newRoom, state) do
    state =
      update_in(state, [Access.key!(:rooms)], fn rooms ->
        Arrays.append(rooms, newRoom)
      end)

    state
  end

  def remove_room(value, state) do
    state =
      update_in(state, [Access.key!(:rooms)], fn rooms ->
        Arrays.new(Enum.reject(rooms, fn room -> room.game_id == value.game_id end))
      end)

    state
  end

  def get_id(state) do
    id = state.next_id
    state = Map.put(state, :next_id, id + 1)
    {id, state}
  end
end
