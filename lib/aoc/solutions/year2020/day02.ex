defmodule Aoc.Solutions.Year2020.Day02 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&parse/1)
    |> Enum.count(&has_proper_count/1)
  end

  @impl true
  def gold(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&parse/1)
    |> Enum.count(&has_proper_positons/1)
  end

  defp has_proper_count(pass) do
    %{min: min, max: max, char: char, password: password} = pass

    count =
      password
      |> String.split("", trim: true)
      |> Enum.count(&(&1 == char))

    count >= min and count <= max
  end

  def has_proper_positons(pass) do
    %{min: min, max: max, char: char, password: password} = pass

    min_match = String.at(password, min - 1) == char
    max_match = String.at(password, max - 1) == char
    min_match != max_match
  end

  @spec parse(String.t()) ::
          %{min: integer, max: integer, char: String.t(), password: String.t()}
  def parse(line) do
    [min, max, char, _, password] = String.split(line, ~r/[-: ]/)

    %{
      min: String.to_integer(min),
      max: String.to_integer(max),
      char: char,
      password: password
    }
  end
end
