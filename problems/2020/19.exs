defmodule Aoc2020.Problem19a do
  defp parse_rule(rule) do
    case rule do
      "a" -> :a
      "b" -> :b
      _ -> String.split(rule, " | ") |> Enum.map(fn combination ->
             String.split(combination, " ") |> Enum.map(&String.to_integer/1)
           end)
    end
  end

  def rules_map(rules) do
    rules
    |> String.replace("\"", "")
    |> String.split("\n")
    |> Enum.filter(fn "" -> false; _ -> true end)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [num, val] -> {String.to_integer(num), parse_rule(val)} end)
    |> Map.new
  end

  defp combine(combinations, append) when is_binary(append) do
    case combinations do
      [] -> [append]
      _ -> combinations |> Enum.map(fn combo -> combo <> append end)
    end
  end

  defp combine(combinations, append) when is_list(append) do
    case combinations do
      [] -> append
      _ -> Enum.flat_map(combinations, fn combo ->
        Enum.map(append, fn a -> combo <> a end)
      end)
    end
  end

  def unroll_rule(map, rule) do
    Enum.reduce(rule, [], fn i, combos ->
      combine(combos, unroll(map, map[i]))
    end)
  end

  def unroll(_map, :a), do: "a"

  def unroll(_map, :b), do: "b"

  def unroll(map, list_of_rules) do
    Enum.flat_map(list_of_rules, &unroll_rule(map, &1))
  end

  def combinations(map, n), do: unroll(map, map[n])

  def p1(input_file) do
    %{rules: rules, messages: messages} = read_file(input_file)
    valid_rules_for_42 = combinations(rules, 42) |> MapSet.new
    valid_rules_for_31 = combinations(rules, 31) |> MapSet.new
    length_of_token = combinations(rules, 42) |> Enum.at(0) |> String.length

    IO.inspect %{v42: valid_rules_for_42, v31: valid_rules_for_31}

    messages
    |> Enum.map(&split_message(&1, length_of_token))
    |> Enum.filter(fn [_, _, _] -> true; _ -> false end)
    |> Enum.filter(fn [a, b, c] ->
      MapSet.member?(valid_rules_for_42, a) && MapSet.member?(valid_rules_for_42, b) && MapSet.member?(valid_rules_for_31, c)
    end)
    |> length
  end

  defp split_message("", _), do: []
  defp split_message(msg, len), do: [String.slice(msg, 0, len) | split_message(String.slice(msg, len..-1), len)]

  def p2(input_file) do
    %{rules: rules, messages: messages} = read_file(input_file)
    valid_rules_for_42 = combinations(rules, 42) |> MapSet.new
    valid_rules_for_31 = combinations(rules, 31) |> MapSet.new
    length_of_token = combinations(rules, 42) |> Enum.at(0) |> String.length

    messages
    |> Enum.map(&split_message(&1, length_of_token))
    |> Enum.map(fn chunks -> Enum.split_while(chunks, &MapSet.member?(valid_rules_for_42, &1)) end)
    |> Enum.filter(fn {group_42, group_31} -> length(group_42) >= 2 && length(group_31) >= 1 end)
    |> Enum.filter(fn {_, group_31} -> Enum.all?(group_31, &MapSet.member?(valid_rules_for_31, &1)) end)
    |> Enum.filter(fn {g42, g31} -> length(g42) > length(g31) end)
    |> length
  end

  def read_file(file) do
    {:ok, content} = File.read(file)
    [rules, message] = String.split(content, "\n\n")
    %{
      rules: rules |> rules_map,
      messages: message |> String.split("\n")
    }
  end
end

AOC.runner &Aoc2020.Problem19a.p1/1, [
  "problems/2020/19.input",
]
AOC.runner &Aoc2020.Problem19a.p2/1, [
  "problems/2020/19.input",
]
