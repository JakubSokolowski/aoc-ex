defmodule Aoc.Solutions.Year2024.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day03

  @year 2024
  @day 3
  @test_input "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  describe "silver/1" do
    test "should solve silver for test input" do
      result = silver(@test_input)

      assert result == 161
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 184_511_516
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      result = gold(@test_input)

      assert result == 48
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 90_044_227
    end
  end
end
