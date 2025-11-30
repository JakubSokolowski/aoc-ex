defmodule Aoc.Solver do
  @moduledoc false
  require Logger

  @spec get_problem!(year :: integer, day :: integer) :: map
  def get_problem!(year, day) do
    %{
      year: year,
      day: day,
      code: "code",
      problem_url: "https://adventofcode.com/#{year}/day/#{day}",
      problem_input_url: "https://adventofcode.com/#{year}/day/#{day}/input"
    }
  end

  @spec solve_problem(year :: integer, day :: integer, part :: :silver | :gold) :: any
  def solve_problem(year, day, part) do
    input = fetch_input(year, day)
    solution = get_solution_module(year, day)

    case part do
      :silver -> solution.silver(input)
      :gold -> solution.gold(input)
    end
  end

  @spec get_solution_module(year :: integer, day :: integer) :: module
  def get_solution_module(year, day) do
    module_name = "Elixir.Aoc.Solutions.Year#{year}.Day#{pad_day(day)}"
    String.to_existing_atom(module_name)
  end

  @spec get_solution_source_code(year :: integer, day :: integer) :: String.t()
  def get_solution_source_code(year, day) do
    module = get_solution_module(year, day)

    filename =
      module
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> Kernel.<>(".ex")

    solutions_path = Application.fetch_env!(:aoc, :solutions_path)
    path = Path.join([solutions_path, "year#{year}", filename])

    Logger.info("Attempting to read module #{module} from #{path}")
    Logger.info("Path contents: #{inspect(File.ls(solutions_path))}")

    Logger.info("Year path contents: #{inspect(File.ls(Path.join([solutions_path, "year#{year}"])))}")

    case File.read(path) do
      {:ok, source_code} ->
        source_code

      {:error, reason} ->
        raise "Failed to read source file for #{inspect(module)}: #{reason}"
    end
  end

  @spec pad_day(integer) :: String.t()
  defp pad_day(day) do
    String.pad_leading("#{day}", 2, "0")
  end

  @spec get_input_file_path(year :: integer, day :: integer) :: String.t()
  def get_input_file_path(year, day) do
    padded_day = pad_day(day)

    Path.join([
      :code.priv_dir(:aoc),
      "static",
      "inputs",
      "#{year}",
      "day#{padded_day}.txt"
    ])
  end

  @spec fetch_input(year :: integer, day :: integer) :: String.t()
  def fetch_input(year, day) do
    padded_day = pad_day(day)
    file_path = get_input_file_path(year, day)

    case File.read(file_path) do
      {:ok, content} -> content
      {:error, _} -> raise "Failed to read input file for Year #{year}, Day #{padded_day}"
    end
  end

  @spec get_adjacent_solutions(integer(), integer()) :: %{
          prev: {integer, integer} | nil,
          next: {integer, integer} | nil
        }
  def get_adjacent_solutions(year, day) do
    # First check the same year
    prev = find_prev_solution(year, day)
    next = find_next_solution(year, day)

    %{
      prev: prev,
      next: next
    }
  end

  defp find_prev_solution(year, day) do
    cond do
      # Check previous day in same year
      day > 1 && solution_exists?(year, day - 1) ->
        {year, day - 1}

      # Check last day of previous year
      year > 2015 && solution_exists?(year - 1, 25) ->
        {year - 1, 25}

      true ->
        nil
    end
  end

  defp find_next_solution(year, day) do
    cond do
      # Check next day in same year
      day < 25 && solution_exists?(year, day + 1) ->
        {year, day + 1}

      # Check first day of next year
      solution_exists?(year + 1, 1) ->
        {year + 1, 1}

      true ->
        nil
    end
  end

  defp solution_exists?(year, day) do
    module_name = "Elixir.Aoc.Solutions.Year#{year}.Day#{pad_day(day)}"

    try do
      _ = String.to_existing_atom(module_name)
      true
    rescue
      ArgumentError -> false
    end
  end
end
