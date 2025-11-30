defmodule Aoc.Solutions.Year2024.Day12Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day12

  @day 12
  @year 2024
  @test_input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @xoxo_input """
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
  """

  @min_input """
  AAAAAA
  AAABBA
  AAABBA
  ABBAAA
  ABBAAA
  AAAAAA
  """

  describe "silver/1" do
    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == 1930
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 1_522_850
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 1206
    end

    test "should solve gold for min input" do
      input = @min_input

      result = gold(input)

      assert result == 368
    end

    test "should solve gold for xoxo input" do
      input = @xoxo_input

      result = gold(input)

      assert result == 436
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 953_738
    end
  end
end
