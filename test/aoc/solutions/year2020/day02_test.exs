defmodule Aoc.Solutions.Year2020.Day02Test do
  use ExUnit.Case

  alias Aoc.Solutions.Year2020.Day02

  describe "silver/1" do
    test "solves the silver challenge for a test input" do
      input = """
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """

      assert Day02.silver(input) == 2
    end
  end

  describe "gold/1" do
    test "solves the gold challenge with a valid input" do
      input = """
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """

      assert Day02.gold(input) == 1
    end
  end
end
