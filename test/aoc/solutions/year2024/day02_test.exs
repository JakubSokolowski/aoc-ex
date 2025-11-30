defmodule Aoc.Solutions.Year2024.Day02Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day02

  @year 2024
  @day 2

  describe "silver/1" do
    test "should solve silver for test input" do
      input = "
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
      "

      result = silver(input)

      assert result == 2
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 510
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = "
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
      "

      result = gold(input)

      assert result == 4
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 553
    end
  end
end
