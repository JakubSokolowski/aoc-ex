tags = [:grid, :maze, :path_finding, :dijkstra, :prio_queue]

defmodule Aoc.Solutions.Year2024.Day16 do
  @moduledoc """
  Tags: #{inspect(tags)}

  Silver: Modified Dijkstra's algorithm - track both position and direction, state is:
  - current_pos
  - current_dir
  - total_cost
  - path

  Use prio queue to get lowest-cost paths first

  Gold: Instead of stopping after first min path, keep sarching, get all paths, get uniq tiles.
  Use :gb_sets for prio queue, and MapSet for visited tiles

  Pretty cool, list comprehension seems cool in elixir, got messed up in part 2 had 2 rewrite
  everything but all good

  """

  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @tags tags

  @dirs [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

  @impl true
  def silver(input) do
    map = Grid.parse(input)
    start = map |> Grid.find_coords("S") |> List.first()
    target = map |> Grid.find_coords("E") |> List.first()

    case find_paths(map, start, target) do
      :no_path -> "No path found"
      {cost, _, _} -> cost
    end
  end

  @impl true
  def gold(input) do
    map = Grid.parse(input)
    start = map |> Grid.find_coords("S") |> List.first()
    target = map |> Grid.find_coords("E") |> List.first()

    case find_paths(map, start, target) do
      :no_path -> "No path found"
      {_cost, _, tiles} -> Enum.count(tiles)
    end
  end

  def find_paths(map, start, target) do
    q = :gb_sets.from_list([{0, start, {0, 1}, [start]}])
    search(map, target, q, %{}, %{}, [], :infinity)
  end

  defp search(map, target, q, costs, paths, best, min) when min != :infinity do
    if :gb_sets.is_empty(q) do
      {min, best, MapSet.new(List.flatten(best))}
    else
      {{cost, _, _, _}, _} = :gb_sets.take_smallest(q)

      if cost > min do
        {min, best, MapSet.new(List.flatten(best))}
      else
        step(map, target, q, costs, paths, best, min)
      end
    end
  end

  defp search(map, target, q, costs, paths, best, min) do
    if :gb_sets.is_empty(q),
      do: :no_path,
      else: step(map, target, q, costs, paths, best, min)
  end

  defp step(map, target, q, costs, paths, best, min) do
    {{cost, pos, dir, path}, rest} = :gb_sets.take_smallest(q)

    if pos == target do
      search(map, target, rest, costs, paths, [path | best], cost)
    else
      neighbors =
        for {dx, dy} <- @dirs,
            next = {elem(pos, 0) + dx, elem(pos, 1) + dy},
            Grid.in_bounds?(map, next),
            Grid.element_at(map, next) != "#",
            next not in path do
          {next, {dx, dy}}
        end

      {new_q, new_costs, new_paths} = process(neighbors, pos, dir, cost, path, rest, costs, paths)
      search(map, target, new_q, new_costs, new_paths, best, min)
    end
  end

  defp process(neighbors, _pos, dir, cost, path, q, costs, paths) do
    Enum.reduce(neighbors, {q, costs, paths}, fn {next, new_dir}, {q, costs, paths} ->
      new_cost = cost + 1 + if(new_dir == dir, do: 0, else: 1000)
      state = {next, new_dir}
      new_path = path ++ [next]

      case Map.get(costs, state, :infinity) do
        old when new_cost < old ->
          {
            :gb_sets.add_element({new_cost, next, new_dir, new_path}, q),
            Map.put(costs, state, new_cost),
            Map.put(paths, state, [new_path])
          }

        old when new_cost == old ->
          {
            :gb_sets.add_element({new_cost, next, new_dir, new_path}, q),
            costs,
            Map.update(paths, state, [new_path], &[new_path | &1])
          }

        _ ->
          {q, costs, paths}
      end
    end)
  end
end
