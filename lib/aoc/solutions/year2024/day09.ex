defmodule Aoc.Solutions.Year2024.Day09 do
  @moduledoc false
  @behaviour Aoc.Solution

  # attempts
  # #1: 90095094087
  # #2: 90489586600
  #
  # couldnt solve it in elixir, so I used python...
  # goddamn immutable data structures
  # pending elixir solution

  @impl true
  def silver(input) do
    calculate(input)
  end

  def calculate(input) do
    initial_list =
      input
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.flat_map(fn {digit, index} ->
        value = if rem(index, 2) == 0, do: div(index, 2)
        List.duplicate(value, String.to_integer(digit))
      end)

    array =
      :array.new([
        {:size, length(initial_list)},
        {:fixed, true},
        {:default, nil}
      ])

    initial_array =
      Enum.reduce(Enum.with_index(initial_list), array, fn {value, index}, arr ->
        :array.set(index, value, arr)
      end)

    size = :array.size(initial_array)
    processed_array = process_array(initial_array, 0, size - 1)

    Enum.reduce(0..(size - 1), 0, fn index, acc ->
      case :array.get(index, processed_array) do
        nil -> acc
        value -> acc + value * index
      end
    end)
  end

  defp process_array(array, left, right) when left >= right, do: array

  defp process_array(array, left, right) do
    left_value = :array.get(left, array)
    right_value = :array.get(right, array)

    cond do
      not is_nil(left_value) ->
        process_array(array, left + 1, right)

      is_nil(right_value) ->
        process_array(array, left, right - 1)

      true ->
        :array.set(left, right_value, array)
        after_second = :array.set(right, nil, array)

        process_array(after_second, left + 1, right - 1)
    end
  end

  def parse_disk(input) do
    input
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.flat_map(fn {digit, index} ->
      value = if rem(index, 2) == 0, do: div(index, 2)
      List.duplicate(value, String.to_integer(digit))
    end)
  end

  def parse_blocks(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 2)
    |> Enum.filter(fn file ->
      case file do
        [block] -> block > 0
        [block, _] -> block > 0
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn {file, id} ->
      case file do
        [block, free] -> {id, block, free}
        [block] -> {id, block, 0}
      end
    end)
  end

  def disk_representation(blocks) do
    Enum.map_join(blocks, "", &to_disk_line/1)
  end

  def checksum(str) do
    str
    |> String.replace(".", "")
    |> String.graphemes()
    |> Enum.filter(fn char -> char != ?. end)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {char, idx}, acc ->
      acc + String.to_integer(char) * idx
    end)
  end

  def squash(str) when is_binary(str) do
    table = :ets.new(:squash_table, [:set])
    chars = String.to_charlist(str)
    size = length(chars)

    chars
    |> Enum.with_index()
    |> Enum.each(fn {char, idx} ->
      :ets.insert(table, {idx, char})
    end)

    last_non_dot = find_last_nonzero(table, size - 1)

    if last_non_dot == nil do
      str
    else
      {_final_table, _} =
        Enum.reduce_while(0..(size - 1), {table, last_non_dot}, fn pos, {curr_table, last_idx} ->
          [{_, curr_char}] = :ets.lookup(curr_table, pos)

          cond do
            last_idx < pos ->
              {:halt, {curr_table, last_idx}}

            curr_char == ?. ->
              [{_, last_char}] = :ets.lookup(curr_table, last_idx)
              :ets.insert(curr_table, {pos, last_char})
              :ets.insert(curr_table, {last_idx, ?.})
              new_last = find_last_nonzero(curr_table, last_idx - 1)
              {:cont, {curr_table, new_last}}

            true ->
              {:cont, {curr_table, last_idx}}
          end
        end)

      result =
        0..(size - 1)
        |> Enum.map(fn idx ->
          [{_, char}] = :ets.lookup(table, idx)
          char
        end)
        |> List.to_string()

      :ets.delete(table)

      result
    end
  end

  defp find_last_nonzero(table, start) do
    start
    |> Stream.iterate(&(&1 - 1))
    |> Stream.take_while(&(&1 >= 0))
    |> Enum.find(nil, fn idx ->
      [{_, char}] = :ets.lookup(table, idx)
      char != ?.
    end)
  end

  def to_disk_line({id, block, free}) do
    block_line = String.duplicate("#{id}", block)
    free_line = String.duplicate(".", free)
    "#{block_line}#{free_line}"
  end

  @impl true
  def gold(_input) do
    "Gold"
  end
end
