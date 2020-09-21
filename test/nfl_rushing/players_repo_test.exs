defmodule NflRushing.PlayersRepoTest do
  use ExUnit.Case

  alias NflRushing.{Player, PlayersRepo}

  setup do
    {:ok, pid} = PlayersRepo.start_link(nil)
    {:ok, pid: pid}
  end

  describe "get/1" do
    test "when :all returns 326 stored players" do
      list = PlayersRepo.get(:all)

      assert [%Player{}| _] = list
      assert 326 = Enum.count(list)
    end

    test "when argument is a function uses it as rule to filter the list" do
      [shane] = PlayersRepo.get(fn x -> x.name == "Shane Wynn" end)

      assert %Player{name: "Shane Wynn"} = shane
    end
  end
end
