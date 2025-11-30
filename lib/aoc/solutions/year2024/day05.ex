defmodule Aoc.Solutions.Year2024.Day05 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    [rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> then(fn [rules, updates] -> [parse_rules(rules), parse_updates(updates)] end)

    updates
    |> Enum.filter(fn update -> update_valid?(rules, update) end)
    |> Enum.map(fn update -> get_middle(update) end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    [rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> then(fn [rules, updates] -> [parse_rules(rules), parse_updates(updates)] end)

    updates
    |> Enum.filter(fn update -> not update_valid?(rules, update) end)
    |> Enum.map(fn update ->
      Enum.sort(update, fn a, b ->
        MapSet.member?(rules, {a, b})
      end)
    end)
    |> Enum.map(fn update -> get_middle(update) end)
    |> Enum.sum()
  end

  def get_middle(list) do
    Enum.at(list, div(length(list), 2))
  end

  def update_valid?(rules, update) do
    update
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [first, second] -> pair_valid?(rules, first, second) end)
  end

  def pair_valid?(rules, first, second) do
    MapSet.member?(rules, {first, second})
  end

  def parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> MapSet.new(fn line ->
      [first, second] = String.split(line, "|")
      {String.to_integer(first), String.to_integer(second)}
    end)
  end

  def parse_updates(updates) do
    updates
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      numbers =
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

      List.wrap(numbers)
    end)
  end
end
