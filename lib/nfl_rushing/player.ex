defmodule NflRushing.Player do
  alias NflRushing.Player

  @derive Jason.Encoder
  defstruct [
    :name,
    :team,
    :position,
    :rushing_attempts_per_game,
    :rushing_attempts,
    :rushing_total_yards,
    :rushing_average_yards,
    :rushing_yards_per_game,
    :rushing_total_touchdowns,
    :rushing_longest_rush,
    :rushing_first_downs,
    :rushing_first_down_percent,
    :rushing_plus_20_yards,
    :rushing_plus_40_yards,
    :rushing_fumbles
  ]

  def match?(%Player{} = player, str) do
    player_name = String.downcase(player.name)
    search_regex = str
      |> String.replace(~r/[\p{P}\p{S}]/, " ") # replace eventual punctuation
      |> String.downcase()
      |> String.trim()
      |> Regex.compile()

    case search_regex do
      {:ok, regex} -> String.match?(player_name, regex)
      {:error, _} -> false
    end
  end
end
