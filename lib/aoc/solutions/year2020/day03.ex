defmodule Aoc.Solutions.Year2020.Day03 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    slope = {3, 1}
    grid = parse_grid(input)
    count_trees(grid, slope)
  end

  @impl true
  def gold(input) do
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    grid = parse_grid(input)

    Enum.reduce(slopes, 1, fn slope, acc ->
      acc * count_trees(grid, slope)
    end)
  end

  @spec parse_grid(String.t()) :: list(list(String.t()))
  defp parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  @spec count_trees(list(list(String.t())), {integer, integer}) :: integer
  def count_trees(grid, slope) do
    count_recursive(grid, {0, 0}, slope, 0)
  end

  @spec count_recursive(
          list(list(String.t())),
          {integer, integer},
          {integer, integer},
          integer
        ) ::
          integer
  defp count_recursive(grid, {x, y} = _position, {right, down} = slope, count) do
    width = length(hd(grid))
    height = length(grid)
    next_x = rem(x + right, width)
    next_y = y + down

    if next_y >= height do
      count
    else
      case get_in(grid, [Access.at(next_y), Access.at(next_x)]) do
        "#" -> count_recursive(grid, {next_x, next_y}, slope, count + 1)
        "." -> count_recursive(grid, {next_x, next_y}, slope, count)
        nil -> count
      end
    end
  end
end
