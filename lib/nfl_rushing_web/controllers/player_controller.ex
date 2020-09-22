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

  def export(conn, params \\ %{}) do
    csv = params
          |> export_params
          |> Players.list_players()
          |> generate_csv()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"players.csv\"")
    |> send_resp(200, csv)
  end

  defp normalized_params(%{} = params) do
    params
    |> Map.take(["query", "page", "per_page", "sort_by", "is_asc"])
    |> Map.new(fn {key, value} ->
        cond do
          key in ["page", "per_page"] -> {key, String.to_integer(value)}
          key in ["is_asc"]           -> {key, String.to_atom(value) }

          true -> {key, value}
        end
      end)
  end

  defp export_params(%{} = params) do
    params
    |> normalized_params
    |> Map.drop(["page", "per_page"])
  end

  defp generate_csv(players) do
    players
    |> Players.export()
    |> CSV.encode(headers: true)
    |> Enum.to_list()
    |> to_string()
  end
end
