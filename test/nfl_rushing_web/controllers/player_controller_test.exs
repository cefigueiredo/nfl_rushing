defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase

  alias NflRushing.Players
  alias NflRushing.Player

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all players", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index))

      assert [%{"name" => _, "team" => _}| _] = json_response(conn, 200)["data"]
    end

    test "returns a paginated list", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index), %{per_page: 10, page: 0})

      assert 326 = json_response(conn, 200)["total"]
      assert 10 = Enum.count(json_response(conn, 200)["data"])
    end
  end
end
