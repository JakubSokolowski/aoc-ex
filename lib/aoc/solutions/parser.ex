defmodule Aoc.Solutions.Parser do
  @moduledoc false
  def parse_nums(input) do
    ~r/-?\d*\.?\d+/
    |> Regex.scan(input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
