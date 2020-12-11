defmodule Aoc2020.Problem11 do
  defp width(map), do: length(Enum.at(map, 0))
  defp height(map), do: length(map)

  def adjacents1(map, x, y) do
    all = [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]

    Enum.reject(all, fn {x, y} -> x < 0 || y < 0 || x >= width(map) || y >= height(map) end)
  end

  def project(map, {x, y}, {dx, dy}) do
    Stream.unfold({x, y}, fn {x, y} ->
      cond do
        x == -1 || y == -1 || x == width(map) || y == height(map) -> nil
        true -> {{x + dx, y + dy}, {x + dx, y + dy}}
      end
    end)
    |> Enum.to_list()
    |> Enum.reverse()
    |> tl
    |> Enum.reverse()
  end

  def adjacents2(map, x, y) do
    [
      project(map, {x, y}, {-1, -1}),
      project(map, {x, y}, {-1, 0}),
      project(map, {x, y}, {-1, 1}),
      project(map, {x, y}, {0, -1}),
      project(map, {x, y}, {0, 1}),
      project(map, {x, y}, {1, -1}),
      project(map, {x, y}, {1, 0}),
      project(map, {x, y}, {1, 1})
    ]
    |> Enum.map(fn projection ->
      projection |> Enum.find(fn {x, y} -> AOC.atmap(map, x, y) != "." end)
    end)
    |> Enum.reject(fn x -> x == nil end)
  end

  def iteration(map, problem) do
    max_near = if problem == 1, do: 4, else: 5

    0..(height(map) - 1)
    |> Enum.map(fn j ->
      0..(width(map) - 1)
      |> Enum.map(fn i ->
        current = AOC.atmap(map, i, j)
        adjacents = if problem == 1, do: adjacents1(map, i, j), else: adjacents2(map, i, j)

        near =
          adjacents
          |> Enum.map(fn {x, y} -> AOC.atmap(map, x, y) end)
          |> Enum.filter(fn s -> s == "#" end)
          |> length

        case current do
          "." -> "."
          "L" -> if near == 0, do: "#", else: "L"
          "#" -> if near >= max_near, do: "L", else: "#"
        end
      end)
    end)
  end

  def occupied(map) do
    map
    |> Enum.map(fn row ->
      row |> Enum.filter(fn cell -> cell == "#" end) |> length
    end)
    |> Enum.sum()
  end

  def problem1(map) do
    new_map = iteration(map, 1)
    if map == new_map, do: occupied(new_map), else: problem1(new_map)
  end

  def problem2(map) do
    new_map = iteration(map, 2)
    if map == new_map, do: occupied(new_map), else: problem2(new_map)
  end
end

{:ok, sample} = AOC.readmap("problems/2020/11.sample")
{:ok, real} = AOC.readmap("problems/2020/11.input")
AOC.runner(&Aoc2020.Problem11.problem1/1, [sample, real])
AOC.runner(&Aoc2020.Problem11.problem2/1, [sample, real])
