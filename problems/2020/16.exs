defmodule Aoc2020.Problem16 do
  def parse_rule(rule) do
    name = rule |> String.split(": ") |> Enum.at(0)
    ranges = rule |> String.split(": ") |> Enum.at(1) |> String.split(" or ")
    [[min1, max1], [min2, max2]] = ranges |> Enum.map(&String.split(&1, "-"))
    r1 = String.to_integer(min1)..String.to_integer(max1)
    r2 = String.to_integer(min2)..String.to_integer(max2)
    {name, fn input -> input in r1 || input in r2 end}
  end

  defp split_input(input),
    do: input
    |> String.split("\n")
    |> Enum.reject(fn s -> s == "" end)

  def strip_file(file) do
    [rules, tickets] = file |> String.split("your ticket:")
    [my, nearby] = tickets |> String.split("nearby tickets:")
    %{rules: split_input(rules),
      my: my |> String.replace("\n", ""),
      nearby: split_input(nearby)}
  end

  def matrix(nearby) do
    nearby |> Enum.map(fn n -> n |> String.split(",") |> Enum.map(&String.to_integer/1) end)
  end

  def traspose(matrix) do
    [first | _] = matrix
    0..length(first)-1
    |> Enum.map(fn i -> matrix |> Enum.map(&Enum.at(&1, i)) end)
  end

  def p1(%{rules: rules, nearby: nearby}) do
    validators = rules |> Enum.map(&parse_rule/1) |> Enum.map(&elem(&1, 1))
    inputs = nearby
             |> Enum.flat_map(&String.split(&1, ","))
             |> Enum.map(&String.to_integer/1)

    inputs
    |> Enum.reject(fn num ->
      Enum.any?(validators, fn val -> val.(num) end)
    end)
    |> Enum.sum
  end

  defp filter_valid_validators(matrix, validators) do
    matrix
    |> Enum.map(fn column ->
      local_validators = validators
                         |> Enum.filter(fn {_, func} -> Enum.all?(column, fn n -> func.(n) end) end)
      {column, local_validators}
    end)
  end

  def p2(%{rules: rules, my: my, nearby: nearby}) do
    matrix = nearby |> matrix |> traspose
    validators = rules |> Enum.map(&parse_rule/1)

    filter_valid_validators(matrix, validators)
    |> IO.inspect
    |> Enum.zip(my |> String.split(",") |> Enum.map(&String.to_integer/1))
    |> Enum.filter(fn
      {"departure" <> _, _} -> true
      _ -> false
    end)
  end
end

{:ok, sample} = File.read("problems/2020/16.sample") |> AOC.fmap(&Aoc2020.Problem16.strip_file/1)
{:ok, sample2} = File.read("problems/2020/16.sample2") |> AOC.fmap(&Aoc2020.Problem16.strip_file/1)
{:ok, input} = File.read("problems/2020/16.input") |> AOC.fmap(&Aoc2020.Problem16.strip_file/1)

AOC.runner(&Aoc2020.Problem16.p1/1, [sample, input])
AOC.runner(&Aoc2020.Problem16.p2/1, [sample2, input])
