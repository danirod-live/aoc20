defmodule Aoc2020.Problem09 do
  def valid?(window, value) do
    window
    |> AOC.combine()
    |> Enum.reject(fn {a, b} -> a == b end)
    |> Enum.any?(fn {a, b} -> a + b == value end)
  end

  defp first_invalid(window, input) do
    window..length(input)
    |> Enum.find(fn i ->
      slice = Enum.slice(input, i - window, window)
      !valid?(slice, Enum.at(input, i))
    end)
  end

  def run1({window, input}) do
    Enum.at(input, first_invalid(window, input))
  end

  defp window_list(input, n) do
    Stream.flat_map(2..(n - 1), fn window_size ->
      Stream.map(0..(n - window_size), fn start ->
        Enum.slice(input, start, window_size)
      end)
    end)
  end

  def run2({window, input}) do
    invalid = first_invalid(window, input)

    answer =
      window_list(input, invalid)
      |> Stream.filter(fn list -> Enum.sum(list) == Enum.at(input, invalid) end)
      |> Enum.take(1)
      |> hd

    Enum.min(answer) + Enum.max(answer)
  end
end

sample_input = [
  35,
  20,
  15,
  25,
  47,
  40,
  62,
  55,
  65,
  95,
  102,
  117,
  150,
  182,
  127,
  219,
  299,
  277,
  309,
  576
]

{:ok, data} =
  AOC.readline("problems/2020/09.input")
  |> AOC.fmap(fn f -> Enum.map(f, &String.to_integer/1) end)

set = [{5, sample_input}, {25, data}]
AOC.runner(&Aoc2020.Problem09.run1/1, set)
AOC.runner(&Aoc2020.Problem09.run2/1, set)
