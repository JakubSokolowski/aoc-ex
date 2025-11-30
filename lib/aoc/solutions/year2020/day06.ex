defmodule Aoc.Solutions.Year2020.Day06 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> parse_groups()
    |> Enum.map(&count_anyone/1)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    input
    |> parse_groups()
    |> Enum.map(&count_everyone/1)
    |> Enum.sum()
  end

  def parse_groups(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def count_anyone(group) do
    group
    |> count_answers()
    |> Enum.map(fn {answer, _count} -> answer end)
    |> Enum.count()
  end

  def count_everyone(group) do
    group
    |> count_answers()
    |> Enum.filter(fn {_answer, count} -> count == length(group) end)
    |> Enum.map(fn {answer, _count} -> answer end)
    |> Enum.count()
  end

  def count_answers(group) do
    group
    |> Enum.join()
    |> String.graphemes()
    |> Enum.reduce(%{}, fn answer, acc ->
      Map.update(acc, answer, 1, &(&1 + 1))
    end)
  end
end
