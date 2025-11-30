defmodule Aoc.Solutions.Year2024.Day04 do
  @moduledoc false
  @behaviour Aoc.Solution

  alias Elixir.Aoc.Solutions.Grid

  @impl true
  def silver(input) do
    input
    |> Grid.parse()
    |> count_word("XMAS")
  end

  @impl true
  def gold(input) do
    input
    |> Grid.parse()
    |> count_x_mases()
  end

  def find_word_lines(grid, {x, y}, word, directions) do
    directions
    |> Enum.map(fn {dx, dy} ->
      {coords, line} = Grid.get_line(grid, {x, y}, {dx, dy}, String.length(word) - 1)

      %{
        start: {x, y},
        delta: {dx, dy},
        coords: coords,
        line: line
      }
    end)
    |> Enum.filter(fn res ->
      res[:line] == String.graphemes(word)
    end)
  end

  def count_x_mases(grid) do
    a_coords = Grid.find_coords(grid, "M")

    directions = [
      {1, 1},
      {1, -1},
      {-1, -1},
      {-1, 1}
    ]

    mas_lines =
      Enum.map(a_coords, fn {x, y} -> find_word_lines(grid, {x, y}, "MAS", directions) end)

    flat_lines = List.flatten(mas_lines)

    middle_points =
      Enum.map(flat_lines, fn line -> Enum.at(line[:coords], 1) end)

    freqs = Enum.frequencies(middle_points)

    overlapping =
      freqs
      |> Enum.filter(fn {_, count} -> count > 1 end)
      |> Enum.map(fn {point, _} -> point end)

    x_masses =
      Enum.filter(flat_lines, fn line -> Enum.member?(overlapping, Enum.at(line[:coords], 1)) end)

    div(Enum.count(x_masses), 2)
  end

  def count_word(grid, word) do
    first_char = String.at(word, 0)
    coords = Grid.find_coords(grid, first_char)

    all_lines =
      Enum.map(coords, fn {x, y} -> find_word_lines(grid, {x, y}, word, Grid.dirs()) end)

    all_lines
    |> Enum.map(fn lines -> Enum.count(lines) end)
    |> Enum.sum()
  end
end
