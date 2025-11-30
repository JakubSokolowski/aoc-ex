defmodule Aoc.Solutions.Year2024.Day03 do
  @moduledoc false
  @behaviour Aoc.Solution

  @patterns %{
    mul: ~r/mul\((\d+),(\d+)\)/,
    do: ~r/do\(\)/,
    dont: ~r/don't\(\)/
  }

  @impl true
  def silver(input) do
    @patterns.mul
    |> Regex.scan(input)
    |> Stream.map(fn [_, l, r] -> String.to_integer(l) * String.to_integer(r) end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    muls = find_matches(input, @patterns.mul)
    dos = find_matches(input, @patterns.do)
    donts = find_matches(input, @patterns.dont)

    muls
    |> Stream.reject(&disabled?(&1, dos ++ donts))
    |> Stream.map(fn {match, _, _} ->
      match
      |> parse_numbers()
      |> Enum.reduce(&*/2)
    end)
    |> Enum.sum()
  end

  defp find_matches(input, pattern) do
    pattern
    |> Regex.scan(input, return: :index)
    |> Enum.map(fn [{start, len} | _] ->
      {String.slice(input, start, len), start, start + len - 1}
    end)
  end

  defp parse_numbers(str) do
    ~r/\d+/
    |> Regex.scan(str)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp disabled?({_, mul_start, _}, controls) do
    controls
    |> Enum.sort_by(fn {_, start, _} -> start end)
    |> Enum.take_while(fn {_, start, _} -> start < mul_start end)
    |> List.last()
    |> case do
      {"don't()", _, _} -> true
      _ -> false
    end
  end
end
