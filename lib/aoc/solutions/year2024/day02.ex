defmodule Aoc.Solutions.Year2024.Day02 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> to_reports()
    |> Enum.count(fn r -> valid(r) end)
  end

  @impl true
  def gold(input) do
    input
    |> to_reports()
    |> Enum.count(fn r -> valid_dampened(r) end)
  end

  def valid_dampened(report) do
    if valid(report) do
      true
    end

    0..(length(report) - 1)
    |> Enum.map(fn x -> List.delete_at(report, x) end)
    |> Enum.any?(fn x -> valid(x) end)
  end

  def valid(report) do
    diffs =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    all_increasing =
      Enum.all?(diffs, fn x -> x >= 1 end)

    all_decreasing =
      Enum.all?(diffs, fn x -> x <= 0 end)

    all_diffs_in_range =
      Enum.all?(diffs, fn x -> abs(x) >= 1 and abs(x) <= 3 end)

    (all_decreasing || all_increasing) && all_diffs_in_range
  end

  def to_reports(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn x ->
      x
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&(&1 != []))
  end
end
