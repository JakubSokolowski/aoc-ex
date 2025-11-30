defmodule Aoc.Solutions.Year2024.Day18Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day18

  @day 18
  @year 2024

  describe "silver/1" do
    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 322
    end
  end

  describe "gold/1" do
    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == {60, 21}
    end
  end
end
