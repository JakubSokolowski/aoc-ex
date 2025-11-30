defmodule Aoc.Solutions.Year2024.Day10Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day10

  alias Aoc.Solutions.Grid

  @day 10
  @year 2024
  @test_input """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  @test_input_min """
  0123
  1234
  8765
  9876
  """

  describe "silver/1" do
    test "should solve silver for test min" do
      input = @test_input_min

      result = silver(input)

      assert result == 1
    end

    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == 36
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 548
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 81
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 1252
    end
  end
end
