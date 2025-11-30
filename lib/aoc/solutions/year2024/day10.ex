tags = [:grid, :flood_fill, :dfs, :bfs, :broot]

defmodule Aoc.Solutions.Year2024.Day10 do
  @moduledoc """
  Tags: #{inspect(tags)}

  For silver, flood the paths, for gold, bfs all paths
  """

  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @tags tags

  @impl true
  def silver(input) do
    grid = Grid.parse(input)
    trail_heads = Grid.find_coords(grid, "0")

    trail_heads
    |> Enum.map(fn trail_head -> trail_head_score(grid, trail_head) end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    grid = Grid.parse(input)
    trail_heads = Grid.find_coords(grid, "0")

    trail_heads
    |> Enum.map(fn trail_head -> trail_head_rating(grid, trail_head) end)
    |> Enum.sum()
  end

  def trail_head_score(grid, trail_head) do
    flooded = flood_hike(grid, trail_head, MapSet.new())

    Enum.count(flooded, fn {x, y} -> grid |> Grid.element_at(x, y) |> String.to_integer() == 9 end)
  end

  def flood_hike(grid, pos, flooded) do
    flooded = MapSet.put(flooded, pos)
    {x, y} = pos
    current_height = grid |> Grid.element_at(x, y) |> String.to_integer()

    floodable_neighbors =
      grid
      |> Grid.non_diagonal_neighbours(pos)
      |> Enum.filter(fn neighbor ->
        not MapSet.member?(flooded, neighbor) and
          can_hike_to?(grid, neighbor, current_height)
      end)

    Enum.reduce(floodable_neighbors, flooded, fn neighbor, acc ->
      flood_hike(grid, neighbor, acc)
    end)
  end

  defp can_hike_to?(grid, pos, current_height) do
    {x, y} = pos
    neighbor_height = grid |> Grid.element_at(x, y) |> String.to_integer()
    neighbor_height - current_height == 1
  end

  def trail_head_rating(grid, trail_head) do
    grid
    |> traverse(trail_head, [trail_head], [])
    |> Enum.count()
  end

  def print_paths(grid, all_paths) do
    Enum.each(all_paths, fn path ->
      IO.inspect(path)
      Grid.print_only_coords(grid, path)
      IO.puts("\n")
    end)
  end

  def traverse(grid, curr_point, curr_path, all_paths) do
    neighbours = Grid.non_diagonal_neighbours(grid, curr_point)

    valid_next_positions =
      Enum.filter(neighbours, fn n -> even_slope?(grid, curr_point, n) end)

    case valid_next_positions do
      [] ->
        case Enum.count(curr_path) do
          10 -> all_paths ++ [curr_path]
          _ -> all_paths
        end

      _ ->
        Enum.reduce(valid_next_positions, all_paths, fn next_pos, paths_acc ->
          {new_x, new_y} = next_pos
          new_curr_path = curr_path ++ [{new_x, new_y}]
          traverse(grid, {new_x, new_y}, new_curr_path, paths_acc)
        end)
    end
  end

  def even_slope?(grid, a, b) do
    {xa, ya} = a
    {xb, yb} = b
    a_value = grid |> Grid.element_at(xa, ya) |> String.to_integer()
    b_value = grid |> Grid.element_at(xb, yb) |> String.to_integer()

    a_value + 1 == b_value
  end
end
