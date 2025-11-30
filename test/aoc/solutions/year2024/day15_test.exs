defmodule Aoc.Solutions.Year2024.Day15Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day15

  alias Aoc.Solutions.Grid

  @day 15
  @year 2024
  @min_input """
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  <^^>>>vv<v>>v<<
  """

  @test_input """
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########

  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  """

  @test_min_wide_input """
  #######
  #...#.#
  #.....#
  #..OO@#
  #..O..#
  #.....#
  #######

  <vv<<^^<<^^
  """

  describe "silver/1" do
    test "should solve silver for min input" do
      input = @min_input

      result = silver(input)

      assert result == 2028
    end

    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == 10_092
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 1_437_174
    end
  end

  describe "move_rows/3" do
    test "should move all boxes ^ move" do
      input = """
      ##############
      ##..........##
      ##..[][][]..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "^"

      {new_map, _} = move_rows(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##..[][][]..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should return all boxes to move for v move" do
      input = """
      ##############
      ##....@.....##
      ##..[][][]..##
      ##...[][]...##
      ##....[]....##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "v"

      {new_map, _} = move_rows(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##..........##
      ##..[]@.[]..##
      ##....[]....##
      ##...[][]...##
      ##....[]....##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should update grid after > move" do
      input = """
      ##############
      ##..........##
      ##..[][][]..##
      ##...[][]...##
      ##...@[]....##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = ">"

      {new_map, _} = move_rows(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##..........##
      ##..[][][]..##
      ##...[][]...##
      ##....@[]...##
      ##..........##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should update grid after < move" do
      input = """
      ##############
      ##..........##
      ##..[][][]..##
      ##...[][]...##
      ##....[]@...##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "<"

      {new_map, _} = move_rows(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##..........##
      ##..[][][]..##
      ##...[][]...##
      ##...[]@....##
      ##..........##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should update grid after > move when moving multiple boxes" do
      input = """
      ##############
      ##..........##
      ##..[][][]..##
      ##...[][]@..##
      ##....[]....##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "<"

      {new_map, _} = move_rows(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##..........##
      ##..[][][]..##
      ##..[][]@...##
      ##....[]....##
      ##..........##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should not move when not touching box grid in > move" do
      input = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "<"

      {new_map, _new_robot} = move_robot_wide(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##....@.....##
      ##..........##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should not move when reached wall ^" do
      input = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "^"

      {new_map, new_robot} = move_robot_wide(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      assert new_robot == robot
      assert String.trim(expected) == String.trim(str_map)
    end

    test "should not move in case of snake edge case" do
      input = """
      ##############
      ##......##..##
      ##...[]##...##
      ##....[]....##
      ##...[].....##
      ##...@......##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "^"

      {new_map, new_robot} = move_robot_wide(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##......##..##
      ##...[]##...##
      ##....[]....##
      ##...[].....##
      ##...@......##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
      assert new_robot == robot
    end

    test "should stop at wall" do
      input = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "^"

      {new_map, _} = move_robot_wide(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      assert String.trim(expected) == String.trim(str_map)
    end

    test "should stop at bottom wall for v move" do
      input = """
      ####################
      ##[]..[]....[]..[]##
      ##[]..........[]..##
      ##.........@[][][]##
      ##....[]..[]..[]..##
      ##..##....[]......##
      ##...[]...[]..[]..##
      ##.....[]..[].[][]##
      ##........[]......##
      ####################
      """

      map = Grid.parse(input)
      robot = map |> Grid.find_coords("@") |> Enum.at(0)
      move = "v"

      {new_map, new_robot} = move_robot_wide(map, robot, move)
      str_map = Grid.to_string(new_map)

      expected = """
      ####################
      ##[]..[]....[]..[]##
      ##[]..........[]..##
      ##.........@[][][]##
      ##....[]..[]..[]..##
      ##..##....[]......##
      ##...[]...[]..[]..##
      ##.....[]..[].[][]##
      ##........[]......##
      ####################
      """

      assert robot == new_robot
      assert String.trim(expected) == String.trim(str_map)
    end
  end

  describe "gold/1" do
    test "should solve gold for test min input" do
      input = @test_min_wide_input

      result = gold(input)

      assert result == 618
    end

    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 9021
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 1_437_468
    end
  end
end
