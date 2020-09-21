defmodule NflRushing.Player do
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

end
