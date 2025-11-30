example = "mix aoc_generate_day 6 2020"

defmodule Mix.Tasks.AocGenerateDay do
  @shortdoc "Generates a template for the AOC day solution"
  @moduledoc """
  #{@shortdoc}

  Generates a module for day code with silver/gold methods and related test module

  ## Example

  ```bash
  #{example}
  ```

  ## Options

  * [day] The day of the month to generate
  * [year] The year to generate, defaults to the current year
  """

  use Igniter.Mix.Task

  @example example

  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      example: @example,
      positional: [{:day, optional: true}, {:year, optional: true}]
    }
  end

  def igniter(igniter, argv) do
    {arguments, _} = positional_args!(argv)

    day = get_day(Map.get(arguments, :day))
    year = get_year(Map.get(arguments, :year))

    full_day = String.pad_leading(to_string(day), 2, "0")
    day_module_name = Igniter.Project.Module.parse("Aoc.Solutions.Year#{year}.Day#{full_day}")

    test_module_name =
      Igniter.Project.Module.parse("Aoc.Solutions.Year#{year}.Day#{full_day}Test")

    input_path = Path.join(["priv", "static", "inputs", to_string(year), "day#{full_day}.txt"])

    dbg({full_day, day_module_name, test_module_name, input_path})

    igniter
    |> Igniter.create_new_file(input_path, "input")
    |> Igniter.Project.Module.create_module(
      day_module_name,
      """
        @behaviour Aoc.Solution

        @impl true
        def silver(_input) do
          "Silver"
        end

        @impl true
        def gold(_input) do
          "Gold"
        end
      """,
      location: :source_folder
    )
    |> Igniter.Project.Module.create_module(
      test_module_name,
      """
      use ExUnit.Case
      import #{day_module_name}

      @day #{full_day}
      @year #{year}
      @test_input \"\"\"
      \"\"\"

      describe "silver/1" do
        test "should solve silver for test input" do
          input = @test_input

          result = silver(input)

          assert result
        end

        test "should solve silver for real input" do
          input = Aoc.Solver.fetch_input(@year, @day)

          result = silver(input)

          assert result
        end
      end

      describe "gold/1" do
        test "should solve gold for test input" do
          input = @test_input

          result = gold(input)

          assert result
        end

        test "should solve gold for real input" do
          input = Aoc.Solver.fetch_input(@year, @day)

          result = gold(input)

          assert result
        end
      end

      """,
      location: :test
    )
  end

  defp get_year(nil) do
    {:ok, now} = DateTime.now("Etc/UTC")
    now.year
  end

  defp get_year(year) when is_binary(year) do
    case Integer.parse(year) do
      {year, _} when year in 2016..2024 -> year
      _ -> raise ArgumentError, "provide a valid day between 2016 and 2024"
    end
  end

  defp get_day(nil) do
    {:ok, now} = DateTime.now("Etc/UTC")
    now.day
  end

  @spec get_day(binary) :: integer
  defp get_day(day) when is_binary(day) do
    case Integer.parse(day) do
      {day, _} when day in 1..25 -> day
      _ -> raise ArgumentError, "provide a valid day between 1 and 25"
    end
  end
end
