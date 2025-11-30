defmodule Aoc.Solutions.Year2020.Day05 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input |> parse_input() |> Enum.map(&seat_id/1) |> Enum.max()
  end

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end

  @impl true
  def gold(input) do
    seat_ids = input |> parse_input() |> Enum.map(&seat_id/1) |> Enum.sort()

    seat_ids
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while(nil, fn
      [a, b], _ when b == a + 1 -> {:cont, nil}
      [a, _], _ -> {:halt, a + 1}
    end)
  end

  def seat_id(pass) do
    list = String.to_charlist(pass)
    row = next_row(list, 0, 0, 128)
    col = next_col(list, 7, 0, 7)
    row * 8 + col
  end

  def next_col(pass, idx, min_col, max_col) do
    next = Enum.at(pass, idx)

    case next do
      ?L ->
        next_col(pass, idx + 1, min_col, div(min_col + max_col - 1, 2))

      ?R ->
        next_col(pass, idx + 1, div(min_col + max_col + 1, 2), max_col)

      _ ->
        min_col
    end
  end

  def next_row(pass, idx, min_seat, max_seat) do
    next = Enum.at(pass, idx)

    case next do
      ?F ->
        next_row(pass, idx + 1, min_seat, div(min_seat + max_seat - 1, 2))

      ?B ->
        next_row(pass, idx + 1, div(min_seat + max_seat + 1, 2), max_seat)

      _ ->
        min_seat
    end
  end
end
