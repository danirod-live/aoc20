defmodule Aoc2020.Problem03 do
  defp coordinates(n, dx, dy) do
    0..trunc((n - 1) / dy) |> Enum.map(&{dx * &1, dy * &1})
  end

  def count(map), do: count(map, {3, 1})

  def count(map, {dx, dy}) do
    width = map |> Enum.at(0) |> Enum.count()
    height = map |> Enum.count()

    coordinates(height, dx, dy)
    |> Enum.filter(fn {x, y} ->
      AOC.atmap(map, rem(x, width), y) == "#"
    end)
    |> Enum.count()
  end

  def minimum(map) do
    [
      count(map, {1, 1}),
      count(map, {3, 1}),
      count(map, {5, 1}),
      count(map, {7, 1}),
      count(map, {1, 2})
    ]
    |> IO.inspect()
    |> Enum.reduce(&(&1 * &2))
  end
end

{:ok, sample} = AOC.readmap("problems/2020/03.sample")
{:ok, lines} = AOC.readmap("problems/2020/03.input")
AOC.runner(&Aoc2020.Problem03.count/1, [sample, lines])
AOC.runner(&Aoc2020.Problem03.minimum/1, [sample, lines])
