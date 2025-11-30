defmodule Aoc.Solutions.Year2020.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2020.Day06

  describe "silver/1" do
    test "should solve silver for test input" do
      input = """
      abc

      a
      b
      c

      ab
      ac

      a
      a
      a
      a

      b
      """

      result = silver(input)

      assert result == 11
    end
  end

  describe "count_answers" do
    test "should count every answer" do
      input = ["ab", "ac"]

      result = count_answers(input)

      assert result
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = """
      abc

      a
      b
      c

      ab
      ac

      a
      a
      a
      a

      b
      """

      result = gold(input)

      assert result == 6
    end
  end
end
