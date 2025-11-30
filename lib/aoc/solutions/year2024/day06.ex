defmodule Aoc.Solutions.Year2024.Day06 do
  @moduledoc false
  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @impl true
  def silver(input) do
    grid = Grid.parse(input)
    [guard] = Grid.find_coords(grid, "^")
    guard_dir = :up
    obstacles = grid |> Grid.find_coords("#") |> MapSet.new()
    path = traverse(grid, guard, guard_dir, obstacles, [guard])

    path
    |> Enum.uniq()
    |> Enum.count()
  end

  def traverse(grid, guard, guard_dir, obstacles, path) do
    next_pos =
      Grid.add_coords(guard, get_delta(guard_dir))

    if Grid.in_bounds?(grid, next_pos) do
      if MapSet.member?(obstacles, next_pos) do
        traverse(grid, guard, turn_right(guard_dir), obstacles, path)
      else
        traverse(grid, next_pos, guard_dir, obstacles, [next_pos | path])
      end
    else
      path
    end
  end

  def traverse_with_dirs(grid, guard, guard_dir, obstacles, path) do
    next_pos =
      Grid.add_coords(guard, get_delta(guard_dir))

    if Grid.in_bounds?(grid, next_pos) do
      {x, y} = next_pos

      if MapSet.member?(obstacles, next_pos) do
        traverse_with_dirs(grid, guard, turn_right(guard_dir), obstacles, path)
      else
        traverse_with_dirs(grid, next_pos, guard_dir, obstacles, [{x, y, guard_dir} | path])
      end
    else
      path
    end
  end

  def get_start_points(grid) do
    [guard] = Grid.find_coords(grid, "^")
    guard_dir = :up
    obstacles = grid |> Grid.find_coords("#") |> MapSet.new()
    path = traverse_with_dirs(grid, guard, guard_dir, obstacles, [])

    path
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()
  end

  def turn_right(dir) do
    case dir do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  def get_delta(dir) do
    case dir do
      :up -> {0, -1}
      :right -> {1, 0}
      :down -> {0, 1}
      :left -> {-1, 0}
    end
  end

  @impl true
  def gold(input) do
    grid = Grid.parse(input)
    start_points = get_start_points(grid)
    total_points = Enum.count(start_points)

    :ets.new(:loop_results, [:set, :public, :named_table])
    :ets.new(:progress_counter, [:set, :public, :named_table])
    :ets.insert(:progress_counter, {:processed, 0})

    progress_pid = spawn_link(fn -> report_progress(total_points) end)

    chunk_size = max(1, div(total_points, System.schedulers_online() * 2))

    start_points
    |> Enum.chunk_every(chunk_size)
    |> Task.async_stream(
      fn chunk ->
        check_chunk_for_loops(grid, chunk)
      end,
      ordered: false,
      timeout: :infinity
    )
    |> Stream.run()

    send(progress_pid, :stop)

    result = :ets.info(:loop_results, :size)
    :ets.delete(:loop_results)
    :ets.delete(:progress_counter)
    result
  end

  defp report_progress(total) do
    receive do
      :stop -> :ok
    after
      100 ->
        [{_, processed}] = :ets.lookup(:progress_counter, :processed)
        percentage = Float.round(processed / total * 100, 1)
        IO.write("\rProcessed #{processed}/#{total} points (#{percentage}%)")
        report_progress(total)
    end
  end

  defp check_chunk_for_loops(grid, chunk) do
    Enum.each(chunk, fn start_point ->
      if adding_causes_loop(grid, start_point) do
        :ets.insert(:loop_results, {start_point, true})
      end

      :ets.update_counter(:progress_counter, :processed, {2, 1})
    end)
  end

  def adding_causes_loop(grid, obstacle) do
    new_grid = Grid.set_point(grid, obstacle, "#")
    guard_coords = Grid.find_coords(new_grid, "^")

    if Enum.empty?(guard_coords) do
      false
    else
      [guard] = guard_coords
      guard_dir = :up
      obstacles = new_grid |> Grid.find_coords("#") |> MapSet.new()
      detect_loop(new_grid, guard, guard_dir, obstacles, MapSet.new())
    end
  end

  def detect_loop(grid, guard, guard_dir, obstacles, path) do
    next_pos = Grid.add_coords(guard, get_delta(guard_dir))
    {x, y} = next_pos

    cond do
      MapSet.member?(path, {x, y, guard_dir}) ->
        true

      not Grid.in_bounds?(grid, next_pos) ->
        false

      MapSet.member?(obstacles, next_pos) ->
        detect_loop(grid, guard, turn_right(guard_dir), obstacles, path)

      true ->
        detect_loop(
          grid,
          next_pos,
          guard_dir,
          obstacles,
          MapSet.put(path, {x, y, guard_dir})
        )
    end
  end
end
