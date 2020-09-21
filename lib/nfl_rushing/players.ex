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

  defp sort(players, params), do: players

  defp paginate(players, %{"page" => page, "per_page" => per_page}) do
    with players_slices <- Enum.chunk_every(players, per_page),
         {:ok, slice} <- Enum.fetch(players_slices, page) do
      slice
    else
      {:error, _} -> []
    end
  end

  defp paginate(players, %{}) do
    Enum.slice(players, 0, 20)
  end
end
