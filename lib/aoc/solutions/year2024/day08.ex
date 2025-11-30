defmodule Aoc.Solutions.Year2024.Day08 do
  @moduledoc false
  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @impl true
  def silver(input), do: solve(input, &pair_antinodes/3)

  @impl true
  def gold(input), do: solve(input, &all_antinodes(&1, &2, &3))

  defp solve(input, antinode_fn) do
    grid = Grid.parse(input)
    values = grid |> Grid.find_all() |> Map.delete(".")

    values
    |> Enum.flat_map(fn {antenna, _} -> get_antinodes(values, antenna, grid, antinode_fn) end)
    |> Enum.filter(&Grid.in_bounds?(grid, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp get_antinodes(values, antenna, grid, func) do
    values
    |> Map.get(antenna)
    |> generate_pairs()
    |> Enum.flat_map(fn {a, b} -> func.(grid, a, b) end)
  end

  defp pair_antinodes(_grid, a, b) do
    {xa, ya} = a
    {xb, yb} = b
    dx = xb - xa
    dy = yb - ya
    [{xa - dx, ya - dy}, {xb + dx, yb + dy}]
  end

  defp all_antinodes(grid, a, b) do
    {xa, ya} = a
    {xb, yb} = b
    dx = xb - xa
    dy = yb - ya

    points_from_a = generate_points(grid, {xa - dx, ya - dy}, {-dx, -dy})
    points_from_b = generate_points(grid, {xb + dx, yb + dy}, {dx, dy})

    points_from_a ++ points_from_b ++ [a, b]
  end

  defp generate_points(grid, start, {dx, dy}) do
    start
    |> Stream.iterate(fn {x, y} -> {x + dx, y + dy} end)
    |> Stream.take_while(&Grid.in_bounds?(grid, &1))
    |> Enum.to_list()
  end

  defp generate_pairs(positions) do
    for a <- positions,
        b <- positions,
        a < b,
        do: {a, b}
  end
end
