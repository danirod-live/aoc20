defmodule Aoc2020.Problem24 do

  def walk(pos, ""), do: pos

  def walk({x, y}, "sw" <> path), do: walk({x, y-1}, path)
  def walk({x, y}, "se" <> path), do: walk({x+1, y-1}, path)
  def walk({x, y}, "nw" <> path), do: walk({x-1, y+1}, path)
  def walk({x, y}, "ne" <> path), do: walk({x, y+1}, path)
  def walk({x, y}, "e" <> path), do: walk({x+1, y}, path)
  def walk({x, y}, "w" <> path), do: walk({x-1, y}, path)

  def walk(path), do: walk({0, 0}, path)

  def reduce_tiles(tiles) do
    tiles |> Enum.reduce(MapSet.new, fn tile, set ->
      if MapSet.member?(set, tile) do
        MapSet.delete(set, tile)
      else
        MapSet.put(set, tile)
      end
    end)
  end

  def min(tiles), do: {tiles |> Enum.map(&elem(&1, 0)) |> Enum.min,
                       tiles |> Enum.map(&elem(&1, 1)) |> Enum.min}
  def max(tiles), do: {tiles |> Enum.map(&elem(&1, 0)) |> Enum.max,
                       tiles |> Enum.map(&elem(&1, 1)) |> Enum.max}
  def area(tiles) do
    {mx, my} = min(tiles)
    {nx, ny} = max(tiles)
    mx-1..nx+1 |> Enum.flat_map(fn x ->
      my-1..ny+1 |> Enum.map(fn y -> {x, y} end)
    end)
  end

  def neighbors({x, y}), do: [
    {x-1, y+1},
    {x, y+1},
    {x+1, y},
    {x+1, y-1},
    {x, y-1},
    {x-1, y}
  ]

  defp flip_tiles(tiles) do
    area(tiles) |> Enum.reduce(MapSet.new, fn cell, set ->
      color = if MapSet.member?(tiles, cell), do: :black, else: :white

      neigh = neighbors(cell) |> Enum.filter(&MapSet.member?(tiles, &1)) |> length

      next_color = cond do
        color == :black && (neigh == 0 || neigh > 2) -> :white
        color == :white && neigh == 2 -> :black
        true -> color
      end

      if next_color == :black do
        MapSet.put(set, cell)
      else
        MapSet.delete(set, cell)
      end
    end)
  end

  defp iterate(tiles) do
    Enum.reduce(1..100, tiles, fn _, set -> flip_tiles(set) end)
  end

  def p1(file), do: file
  |> AOC.readline
  |> AOC.fmap(&Enum.map(&1, fn p -> walk(p) end))
  |> AOC.fmap(&reduce_tiles/1)
  |> AOC.fmap(&MapSet.to_list/1)
  |> AOC.fmap(&length/1)
  |> elem(1)

  def p2(file), do: file
  |> AOC.readline
  |> AOC.fmap(&Enum.map(&1, fn p -> walk(p) end))
  |> AOC.fmap(&reduce_tiles/1)
  |> AOC.fmap(&iterate/1)
  |> AOC.fmap(&MapSet.to_list/1)
  |> AOC.fmap(&length/1)
  |> elem(1)
end

AOC.runner &Aoc2020.Problem24.p2/1, [
  "problems/2020/24.sample",
  "problems/2020/24.input",
]
