defmodule Aoc2020.Problem01 do
  def find2(input) do
    AOC.cartessian(input)
    |> Enum.map(fn {a, b} -> {a + b, a * b} end)
    |> Enum.filter(fn {sum, _} -> sum == 2020 end)
    |> hd
    |> elem(1)
  end

  def find3(input) do
    AOC.cartessian3(input)
    |> Stream.map(fn {a, b, c} -> {a + b + c, a * b * c} end)
    |> Stream.filter(fn {sum, _} -> sum == 2020 end)
    |> Enum.take(1)
    |> hd
    |> elem(1)
  end
end

fake_input = [
  1721,
  979,
  366,
  299,
  675,
  1456
]

{:ok, input} = AOC.readline("problems/2020/01.input")
               |> AOC.fmap(fn f -> Enum.map(f, &String.to_integer/1) end)

AOC.runner &Aoc2020.Problem01.find2/1, [fake_input, input]
AOC.runner &Aoc2020.Problem01.find3/1, [fake_input, input]
