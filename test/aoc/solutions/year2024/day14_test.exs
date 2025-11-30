defmodule Aoc.Solutions.Year2024.Day14Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day14

  alias Aoc.Solutions.Grid

  @day 14
  @year 2024

  describe "silver/1" do
    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 211_692_000
    end
  end

  describe "gold/1" do
    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result
    end
  end
end
