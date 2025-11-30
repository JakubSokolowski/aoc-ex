defmodule Aoc.Solutions.Year2020.Day04 do
  @moduledoc false
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_passport/1)
    |> Enum.count(&has_all_keys/1)
  end

  @impl true
  def gold(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_passport/1)
    |> Enum.filter(&has_all_keys/1)
    |> Enum.count(&all_keys_valid/1)
  end

  @spec parse_passport(String.t()) :: map
  def parse_passport(passport) do
    passport
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.split(&1, ~r/:/, trim: true))
    |> Enum.reduce(%{}, fn [key, value], acc ->
      Map.put(acc, key, value)
    end)
  end

  @spec has_all_keys(map) :: boolean
  def has_all_keys(passport) do
    required_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    Enum.all?(required_keys, &Map.has_key?(passport, &1))
  end

  defp all_keys_valid(passport) do
    passport
    |> validate_keys()
    |> Enum.all?(&elem(&1, 1))
  end

  def validate_keys(passport) do
    Enum.map(passport, fn {key, value} ->
      case key do
        "byr" -> {key, valid_birth_year?(value)}
        "iyr" -> {key, valid_issue_year?(value)}
        "eyr" -> {key, valid_expiration_year?(value)}
        "hgt" -> {key, valid_height?(value)}
        "hcl" -> {key, valid_hair_color?(value)}
        "ecl" -> {key, valid_eye_color?(value)}
        "pid" -> {key, valid_passport_id?(value)}
        "cid" -> {key, true}
      end
    end)
  end

  def valid_birth_year?(value) do
    case String.to_integer(value) do
      year when year >= 1920 and year <= 2002 -> true
      _ -> false
    end
  end

  def valid_issue_year?(value) do
    case String.to_integer(value) do
      year when year >= 2010 and year <= 2020 -> true
      _ -> false
    end
  end

  def valid_expiration_year?(value) do
    case String.to_integer(value) do
      year when year >= 2020 and year <= 2030 -> true
      _ -> false
    end
  end

  def valid_height?(value) do
    case Regex.scan(~r/(\d+)(cm|in)/, value) do
      [[_, height, unit]] ->
        height_num = String.to_integer(height)

        case unit do
          "cm" ->
            height_num >= 150 and height_num <= 193

          "in" ->
            height_num >= 59 and height_num <= 76

          _ ->
            false
        end

      _ ->
        false
    end
  end

  def valid_hair_color?(value) do
    Regex.match?(~r/^#[0-9a-f]{6}$/, value)
  end

  def valid_eye_color?(value) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], value)
  end

  def valid_passport_id?(value) do
    Regex.match?(~r/^\d{9}$/, value)
  end
end
