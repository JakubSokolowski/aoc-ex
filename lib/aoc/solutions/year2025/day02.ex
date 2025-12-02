defmodule Aoc.Solutions.Year2025.Day02 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> parse()
    |> Enum.flat_map(&filter_range(&1, nil))
    |> Enum.sum()
    |> Integer.to_string()
  end

  @impl true
  def gold(input) do
    input
    |> parse()
    |> Enum.flat_map(&filter_range(&1, :all))
    |> Enum.sum()
    |> Integer.to_string()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn line ->
      [first, last] = String.split(line, "-")
      {String.to_integer(first), String.to_integer(last)}
    end)
  end

  defp filter_range({first, last}, mode) do
    Enum.filter(first..last, &invalid?(Integer.to_string(&1), mode))
  end

  defp invalid?(id_str, nil) do
    len = String.length(id_str)
    rem(len, 2) == 0 and check_window?(id_str, div(len, 2))
  end

  defp invalid?(id_str, :all) do
    len = String.length(id_str)
    div(len, 2) > 0 and Enum.any?(1..div(len, 2), &check_window?(id_str, &1))
  end

  defp check_window?(id_str, window) do
    len = String.length(id_str)

    if rem(len, window) == 0 do
      case id_str
           |> String.codepoints()
           |> Enum.chunk_every(window)
           |> Enum.map(&Enum.join/1) do
        [_] -> false
        [first | rest] -> Enum.all?(rest, &(&1 == first))
      end
    else
      false
    end
  end
end
