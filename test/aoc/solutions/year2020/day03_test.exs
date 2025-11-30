defmodule Aoc.Solutions.Year2020.Day03Test do
  use ExUnit.Case

  alias Aoc.Solutions.Year2020.Day03

  @input """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  describe "silver/1" do
    test "solves the silver challenge for a test input" do
      assert Day03.silver(@input) == 7
    end
  end

  describe "gold/1" do
    test "solves the gold challenge with a valid input" do
      assert Day03.gold(@input) == 336
    end
  end
end
