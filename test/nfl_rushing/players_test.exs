defmodule NflRushing.PlayersTest do
  use ExUnit.Case

  alias NflRushing.{Player, Players, PlayersRepo}

  setup do
    {:ok, pid} = PlayersRepo.start_link(nil)
    {:ok, repo: pid}
  end

  describe "players" do
    test "list_players/0 returns all players" do
      list = Players.list_players()

      assert [%Player{}| _] = list
      assert 20 = Enum.count(Players.list_players())
    end

    test "list_players/1 returns all players that matches 'Shane'" do
      result = Players.list_players(%{"query" => "Shane"})

      assert [%Player{name: "Shane Vereen"}, %Player{name: "Shane Wynn"}] = result
    end
  end
end
