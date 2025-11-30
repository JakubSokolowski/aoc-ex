defmodule Aoc.Solutions.Year2024.Day07 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_equation/1)
    |> Enum.filter(fn [target, numbers] -> check(target, 0, numbers) end)
    |> Enum.map(fn [target, _] -> target end)
    |> Enum.sum()
  end

  defp check(target, current, []) do
    current == target
  end

  defp check(target, current, remaining) do
    [next | rest] = remaining
    add_result = check(target, current + next, rest)
    mult_result = check(target, current * next, rest)
    add_result || mult_result
  end

  @impl true
  def gold(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_equation/1)
    |> Enum.filter(fn [target, numbers] -> check_concat(target, 0, numbers) end)
    |> Enum.map(fn [target, _] -> target end)
    |> Enum.sum()
  end

  defp check_concat(target, current, []) do
    current == target
  end

  defp check_concat(target, current, remaining) do
    [next | rest] = remaining
    add_result = check_concat(target, current + next, rest)
    mult_result = check_concat(target, current * next, rest)
    concat_result = check_concat(target, concatenate(current, next), rest)
    add_result || mult_result || concat_result
  end

  def concatenate(left, right) do
    String.to_integer("#{left}#{right}")
  end

  def parse_equation(line) do
    line
    |> String.split(": ", trim: true)
    |> then(fn [target, rest] ->
      [
        String.to_integer(target),
        rest |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      ]
    end)
  end
end
