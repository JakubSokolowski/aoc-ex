defmodule Aoc.Solutions.Year2024.Day04Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day04

  alias Aoc.Solutions.Grid

  @test_input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  @test_input_min """
  XMAS
  SMAX
  XMAS
  XMXS
  """

  describe "silver/1" do
    test "should solve silver for test input" do
      result = silver(@test_input)

      assert result == 18
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(2024, 4)

      result = silver(input)

      assert result == 2500
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      result = gold(@test_input)

      assert result == 9
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(2024, 4)

      result = gold(input)

      assert result == 1933
    end
  end

  describe "count_word/2" do
    test "should count word in min grid" do
      grid = Grid.parse(@test_input_min)

      count = count_word(grid, "XMAS")

      assert count == 4
    end

    test "should count word in grid for test input" do
      grid = Grid.parse(@test_input)

      count = count_word(grid, "XMAS")

      assert count == 18
    end

    test "should count word in grid for real input" do
    end
  end

  describe "find_word/3" do
    test "should find word in grid" do
      grid = Grid.parse(@test_input_min)

      words = find_word_lines(grid, {0, 0}, "XMAS", Grid.dirs())

      assert words == [
               %{
                 line: ["X", "M", "A", "S"],
                 start: {0, 0},
                 coords: [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
                 delta: {1, 0}
               },
               %{
                 line: ["X", "M", "A", "S"],
                 start: {0, 0},
                 coords: [{0, 0}, {1, 1}, {2, 2}, {3, 3}],
                 delta: {1, 1}
               }
             ]
    end
  end
end
