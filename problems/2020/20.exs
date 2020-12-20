defmodule Aoc2020.Problem20 do
  def load_file(file) do
    {:ok, data} = File.read(file)
    data
    |> String.split("\n\n")
    |> Enum.map(fn tile ->
      [header, data] = String.split(tile, ":\n")
      id = String.replace(header, "Tile ", "") |> String.to_integer
      map = data
      |> String.split("\n")
      |> Enum.map(fn line -> String.codepoints(line) end)
      {id, map}
    end)
    |> Map.new
  end

  def borders(tile) do
    north = tile |> Enum.at(0) |> Enum.join
    south = tile |> Enum.at(length(tile) - 1) |> Enum.join
    west = tile |> Enum.map(fn i -> Enum.at(i, 0) end) |> Enum.join
    east = tile |> Enum.map(fn i -> Enum.at(i, length(tile) - 1) end) |> Enum.join
    [north, south, west, east, String.reverse(north), String.reverse(south), String.reverse(east), String.reverse(west)]
  end

  def all_borders(map) do
    map
    |> Map.values
    |> Enum.flat_map(&borders/1)
    |> Enum.frequencies()
  end

  def p1(file) do
    map = load_file(file)
    all_borders = all_borders(map)
    corners = map
    |> Map.to_list
    |> Enum.map(fn {k, v} -> {k, borders(v)} end)
    |> Enum.map(fn {k, v} -> {k, v |> Enum.map(fn b -> all_borders[b] end)} end)
    |> Enum.map(fn {k, v} -> {k, trunc((v |> Enum.sum) / 2)} end)
    |> Enum.filter(fn {k, v} -> v == 6 end)
    |> Enum.map(fn {k, v} -> k end)

    Enum.reduce(corners, 1, fn i, acc -> acc * i end)
  end
end

files = [
  "problems/2020/20.sample",
  "problems/2020/20.input"
]

AOC.runner &Aoc2020.Problem20.p1/1, files
