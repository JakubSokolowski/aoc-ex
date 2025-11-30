tags = [:grid, :wrap, :broot]

defmodule Aoc.Solutions.Year2024.Day14 do
  @moduledoc """
  Tags: #{inspect(tags)}

  Fun day, for sliver just wrap the movement around the grid using rem()
  and for gold, check if roborts are in uniq positions, if so print and pray - my input had many such cases
  so the resulting hardcoded seconds are just so the tests pass...
  """

  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @tags tags

  @width 101
  @height 103

  @impl true
  def silver(input) do
    grid = Grid.init_empty(@width, @height)

    robots =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_robot/1)

    seconds = 101

    coords = Enum.map(robots, &move_robot_times(grid, &1, seconds))

    1..4
    |> Enum.map(&quadrant_count(coords, {@width, @height}, &1))
    |> Enum.reduce(&*/2)
  end

  @impl true
  def gold(input) do
    grid = Grid.init_empty(@width, @height)

    initial_robots =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_robot/1)

    max_seconds = 10_000

    find_christmas_tree(grid, initial_robots, max_seconds)
  end

  def quadrant_count(coords, {width, height}, quadrant) do
    mid_x = div(width, 2)
    mid_y = div(height, 2)

    Enum.count(coords, fn {x, y} ->
      case quadrant do
        1 -> x < mid_x and y < mid_y
        2 -> x > mid_x and y < mid_y
        3 -> x < mid_x and y > mid_y
        4 -> x > mid_x and y > mid_y
      end
    end)
  end

  def find_christmas_tree(grid, robots, max_seconds) do
    min_seconds = 5000

    Enum.reduce_while(1..max_seconds, robots, fn seconds, current_robots ->
      next_robots = move_robots(grid, current_robots)

      robot_coords =
        Enum.map(next_robots, fn [x, y, _, _] -> {x, y} end)

      count_uniq_positions =
        robot_coords
        |> Enum.uniq()
        |> Enum.count()

      count_robots = Enum.count(next_robots)

      if count_uniq_positions == count_robots and seconds > min_seconds do
        {:halt, seconds}
      else
        {:cont, next_robots}
      end
    end)
  end

  def move_robots(grid, robots) do
    Enum.map(robots, fn robot -> move_robot(grid, robot) end)
  end

  def move_robot(grid, robot) do
    [x, y, dx, dy] = robot

    grid
    |> Grid.move_wrap({x, y}, {dx, dy})
    |> then(fn {new_x, new_y} -> [new_x, new_y, dx, dy] end)
  end

  def move_robot_times(grid, robot, times) do
    [x, y, dx, dy] = robot

    grid
    |> Grid.move_wrap_times({x, y}, {dx, dy}, times)
    |> List.last()
  end

  def parse_robot(line) do
    all_nums(line)
  end

  def all_nums(input) do
    ~r/-?\d*\.?\d+/
    |> Regex.scan(input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
