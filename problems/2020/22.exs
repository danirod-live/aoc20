defmodule Aoc2020.Problem22 do
  def load(file) do
    {:ok, content} = File.read(file)

    [p1, p2] =
      content
      |> String.split("\n\n")
      |> Enum.map(fn p ->
        p
        |> String.split("\n")
        |> Enum.reject(&String.starts_with?(&1, "Player"))
        |> Enum.reject(fn
          "" -> true
          _ -> false
        end)
        |> Enum.map(&String.to_integer/1)
      end)

    {p1, p2}
  end

  def combat({[], x}), do: x
  def combat({x, []}), do: x

  def combat({[x1 | xs1], [x2 | xs2]}) do
    if x1 > x2 do
      combat({xs1 ++ [x1, x2], xs2})
    else
      combat({xs1, xs2 ++ [x2, x1]})
    end
  end

  def recursive_combat({[], x}, _), do: {:p2, x}
  def recursive_combat({x, []}, _), do: {:p1, x}

  def recursive_combat({[x1 | xs1], [x2 | xs2]} = state, cache) do
    if MapSet.member?(cache, state) do
      {:p1, [x1 | xs1]}
    else
      winner =
        if length(xs1) >= x1 && length(xs2) >= x2 do
          subdeck1 = Enum.slice(xs1, 0, x1)
          subdeck2 = Enum.slice(xs2, 0, x2)
          {w, _} = recursive_combat({subdeck1, subdeck2}, MapSet.new())
          w
        else
          if x1 > x2, do: :p1, else: :p2
        end

      case winner do
        :p1 -> recursive_combat({xs1 ++ [x1, x2], xs2}, MapSet.put(cache, state))
        :p2 -> recursive_combat({xs1, xs2 ++ [x2, x1]}, MapSet.put(cache, state))
      end
    end
  end

  def compute_score(x) do
    x |> Enum.reverse() |> Enum.with_index(1) |> Enum.map(fn {a, b} -> a * b end) |> Enum.sum()
  end

  def p1(file), do: file |> load |> combat |> compute_score

  def p2(file), do: file |> load |> recursive_combat(MapSet.new()) |> elem(1) |> compute_score
end

inputs = [
  "problems/2020/22.sample",
  "problems/2020/22.input"
]

AOC.runner(&Aoc2020.Problem22.p1/1, inputs)
AOC.runner(&Aoc2020.Problem22.p2/1, inputs)
