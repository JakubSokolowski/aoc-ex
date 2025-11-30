defmodule Aoc.Solutions.Year2020.Day01Test do
  use ExUnit.Case

  alias Aoc.Solutions.Year2020.Day01

  describe "silver/1" do
    test "solves the silver challenge with a valid input" do
      input = """
      1721
      979
      366
      299
      675
      1456
      """

      assert Day01.silver(input) == "514579"
    end

    test "handles case when no pair is found" do
      input = """
      1
      2
      3
      4
      5
      """

      assert Day01.silver(input) == "No pair found"
    end

    test "handles empty input" do
      input = ""
      assert Day01.silver(input) == "No pair found"
    end

    test "handles input with non-integer values" do
      input = """
      1721
      abc
      366
      299
      675
      1456
      """

      assert_raise ArgumentError, fn -> Day01.silver(input) end
    end
  end

  describe "gold/1" do
    test "solves the gold challenge with a valid input" do
      input = """
      1721
      979
      366
      299
      675
      1456
      """

      assert Day01.gold(input) == "241861950"
    end

    test "handles case when no triplet is found" do
      input = """
      1
      2
      3
      4
      5
      """

      assert Day01.gold(input) == "No triplet found"
    end

    test "handles empty input" do
      input = ""
      assert Day01.gold(input) == "No triplet found"
    end

    test "handles input with non-integer values" do
      input = """
      1721
      abc
      366
      299
      675
      1456
      """

      assert_raise ArgumentError, fn -> Day01.gold(input) end
    end
  end
end
