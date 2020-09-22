defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.Players

  action_fallback NflRushingWeb.FallbackController

  def index(conn, params \\ %{}) do
    params = normalized_params(params)
    players = Players.list_players(params)
    count = Players.count_players(params)

    render(conn, "index.json", players: players, params: params, total: count)
  end

  defp normalized_params(%{} = params) do
    Map.merge(%{ "query" => nil, "is_asc" => nil, "sort_by"=> nil, "page" => "0", "per_page" => "20"}, params)
    |> Map.take(["query", "page", "per_page", "sort_by", "is_asc"])
    |> Map.new(fn {key, value} ->
        cond do
          key in ["page", "per_page"] -> {key, String.to_integer(value)}
          key in ["is_asc"]           -> {key, String.to_atom(value) }

          true -> {key, value}
        end
      end)
  end
end
