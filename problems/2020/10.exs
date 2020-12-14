defmodule Aoc2020.Problem10 do
  def run1(adapters) do
    sorted = [0] ++ Enum.sort(adapters)
    members = MapSet.new(sorted)

    {t1, _, t3} =
      Enum.reduce(sorted, {0, 0, 0}, fn next, {j1, j2, j3} ->
        cond do
          MapSet.member?(members, next + 1) -> {j1 + 1, j2, j3}
          MapSet.member?(members, next + 2) -> {j1, j2 + 1, j3}
          MapSet.member?(members, next + 3) -> {j1, j2, j3 + 1}
          next == Enum.max(sorted) -> {j1, j2, j3 + 1}
        end
      end)

    t1 * t3
  end

  def valid?(adapter_list, max_v) do
    full = [0] ++ adapter_list ++ [max_v + 3]
    clean = full |> Enum.reject(fn i -> i == nil end)

    0..(length(clean) - 2)
    |> Enum.all?(fn pos -> Enum.at(clean, pos + 1) - Enum.at(clean, pos) <= 3 end)
  end

  def iterate([], _cache), do: []

  def iterate(adapters, cache) do
    sorted_adapters = Enum.sort(adapters)

    children =
      0..(length(adapters) - 1)
      |> Stream.map(fn i -> List.replace_at(sorted_adapters, i, nil) end)
      |> Stream.filter(fn l -> valid?(l, Enum.max(adapters)) end)
      |> Stream.map(fn xs -> Enum.reject(xs, fn x -> x == nil end) end)

    IO.inspect(length(Enum.to_list(children)))

    new_cache = MapSet.union(cache, MapSet.new(children))

    Enum.reduce(children, new_cache, fn child, cache ->
      iterate(child, cache)
    end)
  end

  def run2(adapters) do
    MapSet.put(iterate(adapters, MapSet.new()), adapters)
  end

  def load(f) do
    {:ok, data} = AOC.readline(f) |> AOC.fmap(fn f -> Enum.map(f, &String.to_integer/1) end)
    data
  end
end

{:ok, sample1} =
  AOC.readline("problems/2020/10.sample")
  |> AOC.fmap(fn f -> Enum.map(f, &String.to_integer/1) end)

{:ok, sample2} =
  AOC.readline("problems/2020/10.sample2")
  |> AOC.fmap(fn f -> Enum.map(f, &String.to_integer/1) end)

{:ok, input} =
  AOC.readline("problems/2020/10.input")
  |> AOC.fmap(fn f -> Enum.map(f, &String.to_integer/1) end)

# AOC.runner(&Aoc2020.Problem10.run1/1, [sample1, sample2, input])
AOC.runner(&Aoc2020.Problem10.run2/1, [sample1, sample2])
