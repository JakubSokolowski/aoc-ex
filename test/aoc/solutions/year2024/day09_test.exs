defmodule Aoc.Solutions.Year2024.Day09Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day09

  @day 09
  @year 2024
  @test_input "2333133121414131402"
  @test_min_input "12345"
  @test_edge_case "000000000000000000111"

  @tag :skip
  describe "silver/1" do
    test "should solve silver for test min input" do
      input = @test_min_input

      result = silver(input)

      assert result
    end

    test "should solve silver for min input" do
      input = @test_input

      result = silver(input)

      assert result
    end

    test "should solve silver for edge case input" do
      input = @test_edge_case

      result = silver(input)

      assert result
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result
    end
  end

  @tag :skip
  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result
    end
  end
end
