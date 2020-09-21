defmodule NflRushing.PlayersRepo do
  use Agent

  alias NflRushing.Player

  require Logger

  @doc """
  Starts the Players storage Agent
  and fetches all the players from the rushing.json file
  """
  @spec start_link(any) :: {:ok, pid} | {:error, any}
  def start_link(_) do
    case Agent.start_link(fn() -> read_rushing_json!() end, name: __MODULE__) do
      {:ok, pid} ->
        records_count = Agent.get(pid, &Enum.count/1)
        Logger.log(:info, "#{__MODULE__} started and loaded #{records_count} players")
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        Logger.log(:info, "#{__MODULE__} was started already.")
        {:ok, pid}

      response -> response
    end
  end

  @doc """
  Retrieves the list of players stored

  ## Examples

        iex> [%NflRushing.Player{}| tail] = NflRushing.PlayersStorage.get(:all)

        iex> PlayersRepo.get(fn y -> y.name == "Shane Wynn" end)
        [
          %NflRushing.Player{
            name: "Shane Wynn",
            position: "WR",
            rushing_attempts: 2,
            rushing_attempts_per_game: 0.4,
            rushing_average_yards: 2.5,
            rushing_first_down_percent: 0,
            rushing_first_downs: 0,
            rushing_fumbles: 0,
            rushing_longest_rush: "7",
            rushing_plus_20_yards: 0,
            rushing_plus_40_yards: 0,
            rushing_total_touchdowns: 0,
            rushing_total_yards: 5,
            rushing_yards_per_game: 1,
            team: "JAX"
          }
        ]
  """
  def get(:all) do
    Agent.get(__MODULE__, & &1)
  end

  def get(fnc) when is_function(fnc) do
    Agent.get(__MODULE__, &Enum.filter(&1, fnc))
  end

  defp read_rushing_json!() do
    rushing_json_path()
    |> File.read!()
    |> Jason.decode!()
    |> parse_players()
  end

  defp rushing_json_path() do
    Path.join(:code.priv_dir(:nfl_rushing), ["rushing.json"])
  end

  defp parse_players(list) when is_list(list), do: Enum.map(list, &parse_player/1)

  defp parse_player(map) when is_map(map) do
    Enum.reduce(map, %Player{}, fn ({key, value}, player) ->
      case key do
        "Player" -> %Player{player | name: value}
        "Team" -> %Player{player | team: value}
        "Pos" -> %Player{player | position: value}
        "Att/G" -> %Player{player | rushing_attempts_per_game: value}
        "Att" -> %Player{player | rushing_attempts: value}
        "Yds" -> %Player{player | rushing_total_yards: value}
        "Avg" -> %Player{player | rushing_average_yards: value}
        "Yds/G" -> %Player{player | rushing_yards_per_game: value}
        "TD" -> %Player{player | rushing_total_touchdowns: value}
        "Lng" -> %Player{player | rushing_longest_rush: value}
        "1st" -> %Player{player | rushing_first_downs: value}
        "1st%" -> %Player{player | rushing_first_down_percent: value}
        "20+" -> %Player{player | rushing_plus_20_yards: value}
        "40+" -> %Player{player | rushing_plus_40_yards: value}
        "FUM" -> %Player{player | rushing_fumbles: value}
        _ ->
          player
      end
    end)
  end
end
