defmodule Aoc.Solutions.Year2024.Day13Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day13

  @day 13
  @year 2024
  @test_input """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """

  describe "silver/1" do
    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == 480
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 35_574
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 875_318_608_908
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 80_882_098_756_071
    end
  end
end
