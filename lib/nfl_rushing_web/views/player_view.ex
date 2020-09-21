defmodule NflRushingWeb.PlayerView do
  use NflRushingWeb, :view
  alias NflRushingWeb.PlayerView

  def render("index.json", %{players: players, params: params, total: total}) do
    %{
      data: render_many(players, PlayerView, "player.json"),
      total: total,
      params: params
    }
  end

  def render("player.json", %{player: player}) do
    player
  end
end
