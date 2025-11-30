defmodule Aoc.Solutions.Year2024.Day01 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> to_lists()
    |> then(fn {left, right} ->
      [
        Enum.sort(left),
        Enum.sort(right)
      ]
    end)
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> abs(b - a) end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    {left, right} = to_lists(input)

    freqs = Enum.frequencies(right)

    left
    |> Enum.map(fn x -> x * Map.get(freqs, x, 0) end)
    |> Enum.sum()
  end

  def to_lists(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> then(fn {left, right} ->
      {
        Enum.map(left, &String.to_integer/1),
        Enum.map(right, &String.to_integer/1)
      }
    end)
  end
end
