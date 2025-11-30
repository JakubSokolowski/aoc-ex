defmodule Aoc.Solutions.Year2024.Day16Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day16

  @day 16
  @year 2024
  @test_input """
  #################
  #...#...#...#..E#
  #.#.#.#.#.#.#.#.#
  #.#.#.#...#...#.#
  #.#.#.#.###.#.#.#
  #...#.#.#.....#.#
  #.#.#.#.#.#####.#
  #.#...#.#.#.....#
  #.#.#####.#.###.#
  #.#.#.......#...#
  #.#.###.#####.###
  #.#.#...#.....#.#
  #.#.#.#####.###.#
  #.#.#.........#.#
  #.#.#.#########.#
  #S#.............#
  #################
  """

  describe "silver/1" do
    test "should solve silver for test input" do
      input = @test_input

      cost = silver(input)

      assert cost == 11_048
    end

    @tag timeout: :infinity
    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 83_444
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 64
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 478
    end
  end
end
