defmodule Aoc.Solutions.Year2025.Day01 do
  @moduledoc false
  @behaviour Aoc.Solution

  @size 100

  @impl true
  def silver(input) do
    input
    |> parse_moves()
    |> Enum.reduce({0, 50}, fn move, {count, pos} ->
      new_pos = apply_move(pos, move)
      {if(new_pos == 0, do: count + 1, else: count), new_pos}
    end)
    |> elem(0)
  end

  @impl true
  def gold(input) do
    input
    |> parse_moves()
    |> Enum.reduce({0, 50}, fn move, {count, pos} ->
      {visits, new_pos} = count_visits(pos, move)
      {count + visits, new_pos}
    end)
    |> elem(0)
  end

  defp parse_moves(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<dir, steps::binary>> ->
      {<<dir>>, String.to_integer(steps)}
    end)
  end

  defp apply_move(pos, {"R", steps}), do: rem(pos + steps, @size)
  defp apply_move(pos, {"L", steps}), do: rem(pos - steps + @size, @size)

  defp count_visits(pos, {dir, move}) do
    steps = rem(move, @size)
    new_pos = apply_move(pos, {dir, steps})

    visits =
      case {dir, pos} do
        {"R", _} -> div(pos + move, @size)
        {"L", 0} -> div(move, @size)
        {"L", _} -> div(@size - pos + move, @size)
      end

    {visits, new_pos}
  end
end
