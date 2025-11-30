defmodule Aoc.Solutions.Year2024.Day18 do
  @behaviour Aoc.Solution
  alias Aoc.Solutions.Parser
  alias Aoc.Solutions.Grid
  @dirs [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
  # Number of points to check per process
  @chunk_size 100

  @impl true
  def silver(input) do
    coords = parse_coords(input) |> Enum.take(1024)
    grid = build_grid(coords, {71, 71})
    start = {0, 0}
    target = {70, 70}
    Grid.print(grid)

    case find_path(grid, start, target) do
      :no_path -> "No path found"
      cost -> cost
    end
  end

  @impl true
  def gold(input) do
    coords = parse_coords(input)
    total_coords = Enum.count(coords)

    chunks =
      1024..total_coords
      |> Enum.chunk_every(@chunk_size)
      |> Enum.map(&Range.new(List.first(&1), List.last(&1)))

    tasks =
      Enum.map(chunks, fn range ->
        Task.async(fn ->
          find_blocking_point_in_range(coords, range)
        end)
      end)

    result =
      Task.yield_many(tasks, :infinity)
      |> Enum.find_value(fn {_task, result} ->
        case result do
          {:ok, {:found, point}} -> point
          _ -> nil
        end
      end)

    case result do
      nil -> "No blocking point found"
      point -> point
    end
  end

  def find_blocking_point_in_range(coords, range) do
    Enum.find_value(range, fn n ->
      {x, y} = point = Enum.at(coords, n - 1)
      IO.puts("Process #{inspect(self())} checking point {#{x}, #{y}} #{n}")

      coords
      |> Enum.take(n)
      |> check_path_found()
      |> case do
        :no_path -> {:found, point}
        _ -> nil
      end
    end)
  end

  def check_path_found(coords) do
    grid = build_grid(coords, {71, 71})
    start = {0, 0}
    target = {70, 70}
    find_path(grid, start, target)
  end

  def build_grid(coords, {width, height}) do
    grid = Grid.init_empty(width, height)

    Enum.reduce(coords, grid, fn point, acc ->
      Grid.set_point(acc, point, "#")
    end)
    |> Grid.set_point({0, 0}, "S")
    |> Grid.set_point({width - 1, height - 1}, "E")
  end

  def parse_coords(input) do
    input
    |> Parser.parse_nums()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [x, y] -> {x, y} end)
  end

  def find_path(map, start, target) do
    q = :gb_sets.from_list([{0, start, {0, 1}}])
    search(map, target, q, %{})
  end

  defp search(map, target, q, costs) do
    if :gb_sets.is_empty(q) do
      :no_path
    else
      {{cost, pos, dir}, rest} = :gb_sets.take_smallest(q)

      if pos == target do
        cost
      else
        neighbors =
          for {dx, dy} <- @dirs,
              next = {elem(pos, 0) + dx, elem(pos, 1) + dy},
              Grid.in_bounds?(map, next),
              Grid.element_at(map, next) != "#" do
            {next, {dx, dy}}
          end

        {new_q, new_costs} = process(neighbors, pos, dir, cost, rest, costs)
        search(map, target, new_q, new_costs)
      end
    end
  end

  defp process(neighbors, _pos, _dir, cost, q, costs) do
    Enum.reduce(neighbors, {q, costs}, fn {next, new_dir}, {q, costs} ->
      new_cost = cost + 1
      state = {next, new_dir}

      case Map.get(costs, state, :infinity) do
        old when new_cost < old ->
          {
            :gb_sets.add_element({new_cost, next, new_dir}, q),
            Map.put(costs, state, new_cost)
          }

        _ ->
          {q, costs}
      end
    end)
  end
end
