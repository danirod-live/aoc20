defmodule Aoc2020.Problem05 do
  defp locate(str, min, max) when str == "F" or str == "L", do: min
  defp locate(str, min, max) when str == "B" or str == "R", do: max

  defp locate("F" <> more, min, max) do
    rows = max - min + 1
    locate(more, min, max - div(rows, 2))
  end

  defp locate("B" <> more, min, max) do
    rows = max - min + 1
    locate(more, min + div(rows, 2), max)
  end

  defp locate("L" <> more, min, max) do
    rows = max - min + 1
    locate(more, min, max - div(rows, 2))
  end

  defp locate("R" <> more, min, max) do
    rows = max - min + 1
    locate(more, min + div(rows, 2), max)
  end

  def locate(str, total), do: locate(str, 0, total - 1)

  def seat(str) do
    row_str = str |> String.slice(0..6)
    col_str = str |> String.slice(7..9)
    {locate(row_str, 128), locate(col_str, 8)}
  end

  def id({row, col}), do: row * 8 + col

  def problem1(list) do
    list
    |> Stream.map(&seat/1)
    |> Stream.map(&id/1)
    |> Enum.max()
  end

  def problem2(list) do
    all_seats = Enum.flat_map(0..127, fn row -> Enum.map(0..7, fn col -> {row, col} end) end)
    used_seats = list |> Stream.map(&seat/1)

    candidates =
      all_seats
      |> Enum.reject(fn seat -> seat in used_seats end)
      |> Enum.map(&id/1)

    candidates
    |> Enum.reject(fn seat -> (seat - 1) in candidates && (seat + 1) in candidates end)
  end
end

AOC.runner(&Aoc2020.Problem05.id/1, [{44, 5}, {70, 7}, {14, 7}, {102, 4}])

cases = [
  "FBFBBFFRLR",
  "BFFFBBFRRR",
  "FFFBBBFRRR",
  "BBFFBBFRLL"
]

AOC.runner(&Aoc2020.Problem05.seat/1, cases)
{:ok, lines} = AOC.readline("problems/2020/05.input")
IO.inspect(Aoc2020.Problem05.problem1(lines), label: "Problem1: ")

IO.inspect(Aoc2020.Problem05.problem2(lines))
