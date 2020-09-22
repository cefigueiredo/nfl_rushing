defmodule NflRushing.Players do
  @moduledoc """
  The Players context.
  """

  alias NflRushing.{PlayersRepo, Player}

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players(params \\ %{}) do
    get_players(params)
    |> sort(params)
    |> paginate(params)
  end

  def count_players(params) do
    get_players(params)
    |> Enum.count()
  end

  defp get_players(%{"query" => nil}), do: get_players(:all)
  defp get_players(%{"query" => name}) do
    PlayersRepo.get(fn x -> Player.match?(x, name) end)
  end
  defp get_players(_) do
    PlayersRepo.get(:all)
  end

  defp sort(players, %{"sort_by" => sort}) when bit_size(sort) == 0, do: players

  defp sort(players, %{"sort_by" => key, "is_asc" => is_asc} = params) do
    atom_key = String.to_atom(key)

    sort_criteria_function = case {atom_key, is_asc} do
      {atom_key, true} ->
        fn (player_a, player_b) ->
          parsed_value(player_a, atom_key) <= parsed_value(player_b, atom_key)
        end

      {atom_key, _} ->
        fn (player_a, player_b) ->
          parsed_value(player_a, atom_key) >= parsed_value(player_b, atom_key)
        end
    end

    Enum.sort(players, sort_criteria_function)
  end

  defp sort(players, params) do
    players
  end

  defp paginate([], _), do: []

  defp paginate(players, %{"page" => page, "per_page" => per_page}) do
    start = if (page > 0), do: page * per_page, else: 0

    Enum.slice(players, start, per_page)
  end

  defp paginate(players, %{}) do
    Enum.slice(players, 0, 10)
  end

  defp parsed_value(player, atom_key) do
    player |> Map.get(atom_key) |> parse_int
  end

  defp parse_int(value) when is_number(value), do: value
  defp parse_int(value) do
    case value |> String.replace(",", "") |> Integer.parse() do
      {int, _} -> int
      :error -> value
    end
  end
end
