defmodule Aoc2020.Problem04 do
  defp process_input([]), do: []

  defp process_input([line1, "" | more_lines]),
    do: [line1 | process_input(more_lines)]

  defp process_input([line1, line2 | more_lines]),
    do: process_input([line1 <> " " <> line2 | more_lines])

  def read_file(path) do
    {:ok, data} = File.read(path)
    data |> String.split("\n") |> process_input
  end

  defp valid1?(passport) do
    tokens = String.split(passport, " ")
    Enum.count(tokens) == 8 || (Enum.count(tokens) == 7 && !String.contains?(passport, "cid"))
  end

  def problem1(data) do
    data
    |> Enum.filter(&valid1?/1)
    |> Enum.count()
  end

  defp valid_data?(_, nil, _), do: false

  defp valid_data?(:range, value, {min, max}) do
    case Integer.parse(value) do
      :error -> false
      {x, ""} -> x >= min && x <= max
    end
  end

  defp valid_data?(:height, value, _) do
    case Integer.parse(value) do
      :error -> false
      {x, "cm"} -> x >= 150 && x <= 193
      {x, "in"} -> x >= 59 && x <= 76
      {x, _} -> false
    end
  end

  defp valid_data?(:eye, value, _) do
    valids = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    Enum.any?(valids, &(value == &1))
  end

  defp valid_data?(:color, value, _) do
    String.match?(value, ~r/^#[[:xdigit:]]{6}$/)
  end

  defp valid_data?(:passport, value, _) do
    String.match?(value, ~r/^[[:digit:]]{9}$/)
  end

  defp valid2?(line) do
    passport =
      line
      |> String.split(" ")
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.map(fn [k, v] -> {k, v} end)
      |> Map.new()

    valid_data?(:range, passport["byr"], {1920, 2002}) &&
      valid_data?(:range, passport["iyr"], {2010, 2020}) &&
      valid_data?(:range, passport["eyr"], {2020, 2030}) &&
      valid_data?(:height, passport["hgt"], {}) &&
      valid_data?(:color, passport["hcl"], {}) &&
      valid_data?(:eye, passport["ecl"], {}) &&
      valid_data?(:passport, passport["pid"], {})
  end

  def problem2(data) do
    data
    |> Enum.filter(&valid2?/1)
    |> Enum.count()
  end
end

sample_data = Aoc2020.Problem04.read_file("problems/2020/04.sample")
real_data = Aoc2020.Problem04.read_file("problems/2020/04.input")
invalid_data = Aoc2020.Problem04.read_file("problems/2020/04.sample2")
valid_data = Aoc2020.Problem04.read_file("problems/2020/04.sample3")

AOC.runner(&Aoc2020.Problem04.problem1/1, [sample_data, real_data])
AOC.runner(&Aoc2020.Problem04.problem2/1, [invalid_data, valid_data, real_data])
