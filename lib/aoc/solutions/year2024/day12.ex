tags = [:grid, :flood_fill, :broot]

defmodule Aoc.Solutions.Year2024.Day12 do
  @moduledoc """
  Tags: #{inspect(tags)}

  For silver, find all regions using flood fill, get perimeter by counting
  non-diagonal neighbours that are not in the region.

  For gold, find the total number of sides by:

  - getting all sides
  - getting unique sides, by grouping by sorting and grouping by x/y axis
  """

  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @tags tags

  @impl true
  def silver(input) do
    grid = Grid.parse(input)
    all_regions = get_all_regions(grid)

    all_regions
    |> Enum.map(fn region ->
      get_area(region) * get_perimeter(grid, region)
    end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    grid = Grid.parse(input)
    all_regions = get_all_regions(grid)

    all_regions
    |> Enum.map(fn region ->
      area = get_area(region)

      sides =
        grid
        |> get_perimeter_points(region)
        |> count_sides()

      area * sides
    end)
    |> Enum.sum()
  end

  defp count_sides(points) do
    points
    |> Enum.group_by(fn {_, _, side} -> side end, fn {x, y, _} -> {x, y} end)
    |> Enum.map(&count_side_group/1)
    |> Enum.sum()
  end

  defp count_side_group({side, points}) do
    case side do
      side when side in [:top, :bottom] -> hor_segments(points)
      side when side in [:left, :right] -> vert_segments(points)
    end
  end

  defp hor_segments(points) do
    count_segments(points, fn {x, _} -> x end, fn {_, y} -> y end)
  end

  defp vert_segments(points) do
    count_segments(points, fn {_, y} -> y end, fn {x, _} -> x end)
  end

  defp count_segments(points, sort_by, group_by) do
    # Basically:
    # - group points by 1 axis
    # - in axis group, sort all point by the other axis
    # - iterate over the sorted points, 2 at a time
    # - if gap on other axis is equal to 1, that means that the point beling to the same side
    # - if gap is greater than 1, that means that we found a new side
    points
    |> Enum.group_by(group_by)
    |> Enum.map(fn {_, group} ->
      group
      |> Enum.sort_by(sort_by)
      |> count_sequential_gaps()
    end)
    |> Enum.sum()
  end

  defp count_sequential_gaps(points) do
    points
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(1, fn [p1, p2], acc ->
      if gap?(p1, p2), do: acc + 1, else: acc
    end)
  end

  defp gap?({x1, _}, {x2, _}) when x2 - x1 > 1, do: true
  defp gap?({_, y1}, {_, y2}) when y2 - y1 > 1, do: true
  defp gap?(_, _), do: false

  defp get_area(region) do
    Enum.count(region)
  end

  defp get_perimeter(grid, region) do
    region
    |> MapSet.to_list()
    |> Enum.reduce(0, fn {x, y}, acc ->
      perimeter =
        grid
        |> Grid.non_diagonal_neighbours_oob({x, y})
        |> Enum.count(fn {nx, ny} -> not MapSet.member?(region, {nx, ny}) end)

      acc + perimeter
    end)
  end

  defp get_perimeter_points(grid, region) do
    region
    |> MapSet.to_list()
    |> Enum.map(fn {x, y} ->
      grid
      |> Grid.non_diagonal_neighbours_oob({x, y})
      |> Enum.filter(fn {nx, ny} -> not MapSet.member?(region, {nx, ny}) end)
      |> Enum.map(fn {nx, ny} ->
        {x, y,
         cond do
           nx < x -> :left
           nx > x -> :right
           ny < y -> :top
           ny > y -> :bottom
         end}
      end)
    end)
    |> List.flatten()
  end

  defp get_all_regions(grid) do
    all_points = Grid.all_coords(grid)
    total_points = length(all_points)

    all_points
    |> Enum.reduce({[], MapSet.new()}, fn point, {regions, all_visited} = acc ->
      points_remaining = total_points - MapSet.size(all_visited)

      cond do
        points_remaining == 0 ->
          acc

        MapSet.member?(all_visited, point) ->
          acc

        true ->
          region = get_region(grid, point, MapSet.new(), all_visited)

          {[region | regions], MapSet.union(all_visited, region)}
      end
    end)
    |> elem(0)
  end

  defp get_region(grid, pos, region, all_visited) do
    region = MapSet.put(region, pos)
    all_visited = MapSet.put(all_visited, pos)
    {x, y} = pos
    current_plant = Grid.element_at(grid, x, y)

    region_plants =
      grid
      |> Grid.non_diagonal_neighbours(pos)
      |> Enum.filter(fn neighbor ->
        not MapSet.member?(region, neighbor) and
          same_plant?(grid, neighbor, current_plant)
      end)

    Enum.reduce(region_plants, region, fn neighbor, acc ->
      get_region(grid, neighbor, acc, all_visited)
    end)
  end

  defp same_plant?(grid, pos, current_plant) do
    {x, y} = pos
    neighbor_plant = Grid.element_at(grid, x, y)
    neighbor_plant == current_plant
  end
end
