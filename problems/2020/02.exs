defmodule Aoc2020.Problem02 do
  defp parse_rule(string) do
    [ab, letter, pass] = string |> String.replace(":", "") |> String.split(" ")
    [a, b] = ab |> String.split("-")
    {String.to_integer(a), String.to_integer(b), letter, pass}
  end

  defp is_valid_p1?({min, max, letter, pass}) do
    freqs = pass |> String.codepoints() |> Enum.frequencies()

    case freqs[letter] do
      nil -> false
      n -> n >= min and n <= max
    end
  end

  defp is_valid_p2?({pos1, pos2, letter, pass}) do
    has1 = String.at(pass, pos1 - 1) == letter
    has2 = String.at(pass, pos2 - 1) == letter
    (has1 && !has2) || (has2 && !has1)
  end

  def count_valids(rules, :sleds) do
    rules
    |> Stream.map(&parse_rule/1)
    |> Stream.filter(&is_valid_p1?/1)
    |> Enum.count()
  end

  def count_valids(rules, :toboggans) do
    rules
    |> Stream.map(&parse_rule/1)
    |> Stream.filter(&is_valid_p2?/1)
    |> Enum.count()
  end
end

sample_input = [
  "1-3 a: abcde",
  "1-3 b: cdefg",
  "2-9 c: ccccccccc"
]

{:ok, input} = AOC.readline("problems/2020/02.input")
AOC.runner(&Aoc2020.Problem02.count_valids(&1, :sleds), [sample_input, input])
AOC.runner(&Aoc2020.Problem02.count_valids(&1, :toboggans), [sample_input, input])
