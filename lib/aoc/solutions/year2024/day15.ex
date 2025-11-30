tags = [:grid, :broot, :sokoban]

defmodule Aoc.Solutions.Year2024.Day15 do
  @moduledoc """
  Tags: #{inspect(tags)}

  Erik...Part 1 pretty ok, just move boxes around, wasted a lot of time with
  calcualting the sum by swapping the x/y coords in sum calc.

  Got lost in the sauce with part 2, getting the boxes group to move was fine
  but then moving them not so, had to write tests for every movement edgecase
  like a goddang jr
  """

  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @tags tags

  @impl true
  def silver(input), do: solve_puzzle(input, &move_robot/3, "O")

  @impl true
  def gold(input), do: input |> double() |> solve_puzzle(&move_robot_wide/3, "[")

  defp solve_puzzle(input, mover, box_type) do
    [map, moves] = parse(input)
    robot = map |> Grid.find_coords("@") |> List.first()

    {final_map, _} = Enum.reduce(moves, {map, robot}, fn move, {m, r} -> mover.(m, r, move) end)

    final_map
    |> Grid.find_coords(box_type)
    |> Enum.map(fn {x, y} -> y * 100 + x end)
    |> Enum.sum()
  end

  defp parse(input) do
    [map, moves] = String.split(input, "\n\n", trim: true)
    [Grid.parse(map), moves |> String.replace(~r/[^\^v<>]/, "") |> String.graphemes()]
  end

  defp double(input) do
    input
    |> String.graphemes()
    |> Enum.map_join(
      &case &1 do
        "#" -> "##"
        "O" -> "[]"
        "." -> ".."
        "@" -> "@."
        c -> c
      end
    )
  end

  defp next_pos({x, y}, dir) do
    case dir do
      "^" -> {x, y - 1}
      "v" -> {x, y + 1}
      "<" -> {x - 1, y}
      ">" -> {x + 1, y}
    end
  end

  defp move_robot(map, robot, move) do
    next = next_pos(robot, move)

    case Grid.element_at(map, next) do
      "." -> {Grid.swap_points(map, robot, next), next}
      "#" -> {map, robot}
      "O" -> push_boxes(map, robot, next, move)
    end
  end

  defp push_boxes(map, robot, next, move) do
    boxes = get_boxes_in_line(map, robot, move)
    last_next = next_pos(List.last(boxes), move)

    if Grid.element_at(map, last_next) == "#" do
      {map, robot}
    else
      map
      |> move_box_chain(boxes, move)
      |> Grid.swap_points(robot, next)
      |> then(&{&1, next})
    end
  end

  def move_robot_wide(map, robot, move) do
    next = next_pos(robot, move)

    case Grid.element_at(map, next) do
      "." -> {Grid.swap_points(map, robot, next), next}
      "#" -> {map, robot}
      _ -> move_rows(map, robot, move)
    end
  end

  def move_rows(map, robot, dir) when dir in ["^", "v", "<", ">"] do
    boxes = get_wide_boxes_in_line(map, robot, dir)
    groups = group_by_direction(boxes, dir)
    next = next_pos(robot, dir)

    if Enum.all?(groups, fn {_, boxes} -> can_move?(map, boxes, dir) end) do
      map
      |> move_groups(groups, dir)
      |> Grid.swap_points(robot, next)
      |> then(&{&1, next})
    else
      {map, robot}
    end
  end

  defp move_groups(map, groups, dir) do
    Enum.reduce(groups, map, fn {_, boxes}, acc ->
      boxes
      |> sort_by_direction(dir)
      |> Enum.reduce(acc, &Grid.swap_points(&2, &1, next_pos(&1, dir)))
    end)
  end

  defp sort_by_direction(boxes, dir) do
    case dir do
      "<" -> Enum.sort_by(boxes, &elem(&1, 0))
      ">" -> Enum.sort_by(boxes, &elem(&1, 0), :desc)
      _ -> boxes
    end
  end

  defp get_wide_boxes_in_line(map, robot, move) do
    next = next_pos(robot, move)

    case Grid.element_at(map, next) do
      tile when tile in ["[", "]"] ->
        base = [next | get_wide_boxes_in_line(map, next, move)]

        if move in ["^", "v"] do
          side_dir = if tile == "[", do: ">", else: "<"
          side_pos = next_pos(next, side_dir)
          base ++ [side_pos | get_wide_boxes_in_line(map, side_pos, move)]
        else
          base
        end

      _ ->
        []
    end
  end

  defp group_by_direction(boxes, dir) do
    sort_dir = if dir in ["^", "<"], do: :asc, else: :desc

    boxes
    |> Enum.uniq()
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.sort_by(&elem(&1, 0), sort_dir)
  end

  defp can_move?(map, boxes, dir) do
    Enum.all?(boxes, &(Grid.element_at(map, next_pos(&1, dir)) != "#"))
  end

  defp get_boxes_in_line(map, robot, move) do
    next = next_pos(robot, move)

    if Grid.element_at(map, next) == "O" do
      [next | get_boxes_in_line(map, next, move)]
    else
      []
    end
  end

  defp move_box_chain(map, boxes, move) do
    boxes
    |> Enum.reverse()
    |> Enum.reduce(map, &Grid.swap_points(&2, &1, next_pos(&1, move)))
  end
end
