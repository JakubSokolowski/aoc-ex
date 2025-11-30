defmodule Aoc.Solutions.Year2024.Day17 do
  @tags [:intcode, :cycles, :bitwise]

  @moduledoc """
  Tags #{inspect(@tags)}

  Silver:
  Just impl the ops and run the program

  Gold:
  Inspect a lot of program outputs for different a values to find the pattern - powers of 8!

  - run program and compare outputs
  - if the match, we found the answer
  - if not, find the postion of the first mismatch, then increment the a by 8 ** mismatch

  Program outputs numbers mod 8, so we can check powers of 8, each position can only be 0-7 sof
  if a position is wrong, we need to increment a by enaough to change that specific position,
  while keeping the precious positions correct
  """

  import Bitwise

  @behaviour Aoc.Solution
  alias Aoc.Solutions.Parser

  @impl true
  def silver(input) do
    {{a, b, c}, program} = parse_program(input)
    {_, _, output} = run_program({a, b, c}, program)
    Enum.join(output, ",")
  end

  @impl true
  def gold(input) do
    {{a, b, c}, program} = parse_program(input)
    find_a({a, b, c}, program, program)
  end

  defp find_a(regs, prog, expect, a \\ 0) do
    {_, _, output} = run_program(put_elem(regs, 0, a), prog)

    case compare_outputs(output, expect) do
      :match -> a
      n -> find_a(regs, prog, expect, a + 8 ** n)
    end
  end

  defp compare_outputs(actual, expected, mismatch \\ -1, pos \\ 0) do
    case {actual, expected, mismatch} do
      {[], [], -1} -> :match
      {[], [], pos} -> pos
      {[], [_ | rest], _} -> compare_outputs([], rest, pos, pos + 1)
      {[x | rest_act], [x | rest_exp], m} -> compare_outputs(rest_act, rest_exp, m, pos + 1)
      {[_ | rest_act], [_ | rest_exp], _} -> compare_outputs(rest_act, rest_exp, pos, pos + 1)
    end
  end

  defp parse_program(input) do
    [a, b, c | program] = Parser.parse_nums(input)
    {{a, b, c}, program}
  end

  def run_program(registers, instructions) do
    do_run_program(instructions, {registers, 0, []})
  end

  defp do_run_program(instructions, {registers, pointer, output}) do
    instruction = Enum.at(instructions, pointer)
    operand = Enum.at(instructions, pointer + 1)

    case instruction do
      nil ->
        {registers, pointer, output}

      _ ->
        do_run_program(instructions, execute(registers, instruction, operand, pointer, output))
    end
  end

  def execute(registers = {a, b, c}, opcode, operand, pointer, output) do
    next_pointer = pointer + 2

    case opcode do
      0 -> {div_a(registers, operand), next_pointer, output}
      1 -> {{a, bxor(b, operand), c}, next_pointer, output}
      2 -> {{a, combo(registers, operand) |> rem(8), c}, next_pointer, output}
      3 -> if(a == 0, do: {registers, next_pointer, output}, else: {registers, operand, output})
      4 -> {{a, bxor(b, c), c}, next_pointer, output}
      5 -> {registers, next_pointer, output ++ [combo(registers, operand) |> rem(8)]}
      6 -> {{a, div_value(a, operand, registers), c}, next_pointer, output}
      7 -> {{a, b, div_value(a, operand, registers)}, next_pointer, output}
      _ -> registers
    end
  end

  defp div_a(registers, operand) do
    {a, b, c} = registers
    {div_value(a, operand, registers), b, c}
  end

  defp div_value(value, operand, registers) do
    div(value, Integer.pow(2, combo(registers, operand)))
  end

  defp combo({a, b, c}, operand) when operand in 0..6 do
    case operand do
      op when op in 0..3 -> op
      4 -> a
      5 -> b
      6 -> c
    end
  end
end
