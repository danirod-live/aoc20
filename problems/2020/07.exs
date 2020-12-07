defmodule Aoc2020.Problem07 do
  def can_contain?("shiny gold", _), do: true

  def can_contain?(color, ruletree) do
    children = ruletree[color]

    case children do
      [] -> false
      _ -> Enum.any?(children, fn {child, _} -> can_contain?(child, ruletree) end)
    end
  end

  def child_bags(color, ruletree) do
    ruletree[color]
    |> Enum.map(fn {child_color, child_count} ->
      child_count + child_count * child_bags(child_color, ruletree)
    end)
    |> Enum.sum()
  end

  def problem2(ruletree), do: child_bags("shiny gold", ruletree)

  def problem1(ruletree) do
    candidates =
      ruletree
      |> Enum.reduce(0, fn {color, _contents}, prev ->
        if can_contain?(color, ruletree), do: prev + 1, else: prev
      end)

    candidates - 1
  end

  def parse(rules) do
    rulegen = fn rule ->
      [color, contents] =
        rule
        |> String.replace(".", "")
        |> String.replace(" bags", "")
        |> String.replace(" bag", "")
        |> String.split(" contain ")

      bag_list =
        case contents do
          "no other" ->
            []

          _ ->
            contents
            |> String.split(", ")
            |> Enum.map(fn bag -> String.split(bag, " ", parts: 2) end)
            |> Enum.map(fn [count, color] -> {color, String.to_integer(count)} end)
            |> Map.new()
        end

      {color, bag_list}
    end

    rules
    |> Enum.map(rulegen)
    |> Map.new()
  end
end

{:ok, rules} = AOC.readline("problems/2020/07.input")
IO.inspect(Aoc2020.Problem07.parse(rules) |> Aoc2020.Problem07.problem1(), label: "P1")
IO.inspect(Aoc2020.Problem07.parse(rules) |> Aoc2020.Problem07.problem2(), label: "P2")
