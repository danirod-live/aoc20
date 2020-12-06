defmodule Aoc2020.Problem06 do
  defp process_input([]), do: []

  defp process_input([line1, "" | more_lines]),
    do: [line1 | process_input(more_lines)]

  defp process_input([line1, line2 | more_lines]),
    do: process_input([line1 <> " " <> line2 | more_lines])

  def read_file(path) do
    {:ok, data} = File.read(path)
    data |> String.split("\n") |> process_input
  end

  def answers_or(input) do
    input |> String.split(" ") |> Enum.join() |> String.graphemes() |> Enum.uniq() |> length
  end

  def answers_and(input) do
    count = input |> String.split(" ") |> length
    frequencies = input |> String.graphemes() |> Enum.frequencies() |> Map.delete(" ")
    frequencies |> Enum.filter(fn {_, v} -> v == count end) |> length
  end
end

p1 =
  Aoc2020.Problem06.read_file("problems/2020/06.input")
  |> Enum.map(&Aoc2020.Problem06.answers_or/1)
  |> Enum.sum()

IO.inspect(p1, label: "Problem 1")

p2 =
  Aoc2020.Problem06.read_file("problems/2020/06.input")
  |> Enum.map(&Aoc2020.Problem06.answers_and/1)
  |> Enum.sum()

IO.inspect(p2, label: "Problem 2")
