defmodule Aoc2020.Problem15 do
  def init(input) do
    memory = input
    |> Enum.with_index
    |> Enum.map(fn {inp, turn} -> {inp, [turn + 1]} end)
    |> Map.new
    last = input |> Enum.reverse |> hd
    {length(input)+1, memory, last}
  end

  def last(memory, k, v) do
    case memory[k] do
      nil -> Map.put(memory, k, [v])
      [l | _] -> Map.put(memory, k, [v, l])
    end
  end

  def turn({n, memory, last}) do
    if length(memory[last]) < 2 do
      new_memory = last(memory, 0, n)
      {n + 1, new_memory, 0}
    else
      [a, b | _] = memory[last]
      new_memory = last(memory, a - b, n)
      {n + 1, new_memory, a - b}
    end
  end

  def p1(input) do
    Stream.unfold(init(input), fn {n, memory, last} ->
      next_turn = turn({n, memory, last})
      {next_turn, next_turn}
    end)
    |> Enum.find(fn {t, _, _} -> t == 2021 end)
    |> elem(2)
  end

  def p2(input) do
    Stream.unfold(init(input), fn {n, memory, last} ->
      next_turn = turn({n, memory, last})
      {next_turn, next_turn}
    end)
    |> Enum.find(fn {t, _, _} -> t == 30000001 end)
    |> elem(2)
  end
end

inputs = [
  [0, 3, 6],
  [1, 3, 2],
  [2, 1, 3],
  [1, 2, 3],
  [2, 3, 1],
  [3, 2, 1],
  [3, 1, 2],
  [0,13,1,16,6,17],
]

IO.puts "P1"
AOC.runner &Aoc2020.Problem15.p1/1, inputs

IO.puts "P2"
AOC.runner &Aoc2020.Problem15.p2/1, inputs
