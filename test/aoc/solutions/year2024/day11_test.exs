defmodule Aoc.Solutions.Year2024.Day11Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day11

  @day 11
  @year 2024
  @test_input "125 17"

  describe "silver/1" do
    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == 55_312
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 188_902
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 65_601_038_650_482
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 223_894_720_281_135
    end
  end
end
