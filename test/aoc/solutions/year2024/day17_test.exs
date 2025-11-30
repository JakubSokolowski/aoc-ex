defmodule Aoc.Solutions.Year2024.Day17Test do
  use ExUnit.Case

  import Elixir.Aoc.Solutions.Year2024.Day17

  @day 17
  @year 2024
  @test_input """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """

  @min_program """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
  """

  describe "execute/3" do
    test "should execute adv instruction (opcode 0)" do
      registers = {10, 10, 10}
      opcode = 0
      operand = 2
      pointer = 0

      {result, new_pointer, _output} = execute(registers, opcode, operand, pointer, [])

      assert result == {2, 10, 10}
      assert new_pointer == 2
    end

    test "should execute bxl instruction (opcode 1)" do
      registers = {10, 5, 10}
      opcode = 1
      operand = 3
      pointer = 0

      {result, _pointer, _output} = execute(registers, opcode, operand, pointer, [])

      assert result == {10, 6, 10}
    end

    test "should execute bst instruction (opcode 2)" do
      registers = {10, 5, 10}
      opcode = 2
      operand = 3
      pointer = 0

      {result, _pointer, _output} = execute(registers, opcode, operand, pointer, [])

      assert result == {10, 3, 10}
    end

    test "should execute jnz instruction (opcode 3) when a is 0" do
      registers = {0, 5, 10}
      opcode = 3
      operand = 3
      pointer = 0

      {result, new_pointer, _output} = execute(registers, opcode, operand, pointer, [])

      assert result == registers
      assert new_pointer == 2
    end

    test "should execute jnz instruction (opcode 3) and jump when a is not 0" do
      registers = {4, 5, 10}
      opcode = 3
      operand = 3
      pointer = 0

      {result, new_pointer, _output} = execute(registers, opcode, operand, pointer, [])

      assert result == registers
      assert new_pointer == 3
    end

    test "should execute bxc instruction (opcode 4)" do
      registers = {10, 5, 3}
      opcode = 4
      operand = 2
      pointer = 0

      {result, _pointer, _output} = execute(registers, opcode, operand, pointer, [])

      assert result == {10, 6, 3}
    end
  end

  describe "run_program/2" do
    test "should set register B to 1" do
      registers = {0, 0, 9}
      program = [2, 6]

      {registers, _pointer, _output} = run_program(registers, program)
      {_, b, _} = registers

      assert b == 1
    end

    test "should output 0,1,2 when register A contains 10" do
      registers = {10, 0, 0}
      program = [5, 0, 5, 1, 5, 4]

      result = run_program(registers, program)

      assert result == {{10, 0, 0}, 6, [0, 1, 2]}
    end

    test "should output [4,2,5,6,7,7,7,7,3,1,0] and set A to 0 when register A contains 2024" do
      registers = {2024, 0, 0}
      program = [0, 1, 5, 4, 3, 0]

      result = run_program(registers, program)

      assert result == {{0, 0, 0}, 6, [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]}
    end

    test "should set B to 26 wheb B contains 29" do
      registers = {0, 29, 0}
      program = [1, 7]

      result = run_program(registers, program)

      assert result == {{0, 26, 0}, 2, []}
    end

    test "should set B to 44354 wheb B contains 2024 and C contains 43690" do
      registers = {0, 2024, 43_690}
      program = [4, 0]

      result = run_program(registers, program)

      assert result == {{0, 44_354, 43_690}, 2, []}
    end

    test "should output itself" do
      registers = {117_440, 0, 0}
      program = [0, 3, 5, 4, 3, 0]

      result = run_program(registers, program)

      assert result == {{0, 0, 0}, 6, [0, 3, 5, 4, 3, 0]}
    end
  end

  describe "silver/1" do
    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == "4,6,3,5,6,3,5,2,1,0"
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == "1,5,7,4,1,6,0,3,0"
    end
  end

  describe "gold/1" do
    test "should solve gold for min input" do
      input = @min_program

      result = gold(input)

      assert result == 117_440
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 108_107_574_778_365
    end
  end
end
