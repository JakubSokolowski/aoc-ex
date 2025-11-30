defmodule AocWeb.PageController do
  use AocWeb, :controller

  def home(conn, _params) do
    available = list_solutions()
    solutions = build_solutions_struct(available)

    render(conn, :home, layout: false, solutions: solutions)
  end

  defp list_solutions do
    :code.all_available()
    |> Enum.map(fn {module, _filename, _loaded} -> List.to_string(module) end)
    |> Enum.filter(&solution_module?/1)
    |> Enum.uniq()
  end

  defp solution_module?(module) do
    String.starts_with?(module, "Elixir.Aoc.Solutions.Year") and
      !String.ends_with?(module, "Test")
  end

  defp build_solutions_struct(available) do
    available
    |> Enum.map(&parse_module_name/1)
    |> Enum.group_by(fn {year, _day} -> year end)
    |> Enum.map(fn {year, days} ->
      %{year: year, days: days |> Enum.map(fn {_year, day} -> day end) |> Enum.sort()}
    end)
    |> Enum.sort_by(& &1.year, :desc)
  end

  defp parse_module_name(module) do
    case Regex.run(~r/Elixir\.Aoc\.Solutions\.Year(\d+)\.Day(\d+)/, module) do
      [_, year, day] -> {String.to_integer(year), String.to_integer(day)}
      _ -> nil
    end
  end
end
