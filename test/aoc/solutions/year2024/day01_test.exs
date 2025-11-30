defmodule Aoc.Solutions.Year2024.Day01Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day01

  describe "silver/1" do
    test "should solve silver for test input" do
      input = "
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3"

      result = silver(input)

      assert result == 11
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = "
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3"

      result = gold(input)

      assert result == 31
    end
  end
end
