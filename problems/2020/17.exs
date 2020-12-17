defmodule Aoc2020.Problem17a do
  defp size(layer) do
    rows = length(layer)
    cols = length(Enum.at(layer, 0))
    {rows, cols}
  end

  def load(file) do
    {:ok, data} = AOC.readmap(file)
    data
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index
    |> Enum.reduce(Map.new, fn {row, y}, map ->
      Enum.reduce(row, map, fn {col, x}, m ->
        Map.put(m, [x, y, 0], col)
      end)
    end)
  end

  def get(cube, {x, y, z}) do
    case cube[[x, y, z]] do
      nil -> "."
      layer -> layer
    end
  end

  def set(cube, {x, y, z}, value) do
    Map.put(cube, [x, y, z], value)
  end

  def neighbors(cube, {x, y, z}) do
    to_look = x-1..x+1 |> Enum.flat_map(fn tx ->
      y-1..y+1 |> Enum.flat_map(fn ty ->
        z-1..z+1 |> Enum.map(fn tz -> get(cube, {tx, ty, tz}) end)
      end)
    end)
    |> Enum.filter(fn x -> x == "#" end)

    if get(cube, {x, y, z}) == "#" do
      length(to_look)-1
    else
      length(to_look)
    end
  end

  def range(cube) do
    keys = Map.keys(cube)
    [mx, my, mz] = Enum.min(keys)
    [nx, ny, nz] = Enum.max(keys)
    mx-1..nx+1 |> Enum.flat_map(fn x ->
      my-1..ny+1 |> Enum.flat_map(fn y ->
        mz-1..nz+1 |> Enum.map(fn z -> [x, y, z] end)
      end)
    end)
  end

  def step(cube) do
    range(cube)
    |> Enum.reduce(cube, fn [x, y, z], c ->
      current = get(cube, {x, y, z})
      neigh = neighbors(cube, {x, y, z})
      new = case current do
        "#" -> if neigh == 2 || neigh == 3, do: "#", else: "."
        "." -> if neigh == 3, do: "#", else: "."
      end
      set(c, {x, y, z}, new)
    end)
  end

  def debug(cube) do
    [mx, my, mz] = Enum.min(Map.keys(cube))
    [nx, ny, nz] = Enum.max(Map.keys(cube))
    _ = mz..nz
    |> Enum.map(fn z ->
      IO.puts "z = #{z}"
      mx..nx |> Enum.map(fn x ->
        my..ny |> Enum.map(fn y -> get(cube, {x, y, z}) end) |> Enum.join |> IO.puts
      end)
      IO.puts ""
    end)
    IO.puts ""
    cube
  end

  def p1(map) do
    final_state = 1..6 |> Enum.reduce(map, fn i, m -> step(m) end)
    final_state
    |> Map.values
    |> Enum.filter(fn
      "#" -> true
      "." -> false
    end)
    |> length
  end
end

defmodule Aoc2020.Problem17b do
  defp size(layer) do
    rows = length(layer)
    cols = length(Enum.at(layer, 0))
    {rows, cols}
  end

  def load(file) do
    {:ok, data} = AOC.readmap(file)
    data
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index
    |> Enum.reduce(Map.new, fn {row, y}, map ->
      Enum.reduce(row, map, fn {col, x}, m ->
        Map.put(m, [x, y, 0, 0], col)
      end)
    end)
  end

  def get(cube, {x, y, z, w}) do
    case cube[[x, y, z, w]] do
      nil -> "."
      layer -> layer
    end
  end

  def set(cube, {x, y, z, w}, value) do
    Map.put(cube, [x, y, z, w], value)
  end

  def neighbors(cube, {x, y, z, w}) do
    to_look = x-1..x+1 |> Enum.flat_map(fn tx ->
      y-1..y+1 |> Enum.flat_map(fn ty ->
        z-1..z+1 |> Enum.flat_map(fn tz ->
          w-1..w+1 |> Enum.map(fn tw -> get(cube, {tx, ty, tz, tw}) end)
        end)
      end)
    end)
    |> Enum.filter(fn x -> x == "#" end)

    if get(cube, {x, y, z, w}) == "#" do
      length(to_look)-1
    else
      length(to_look)
    end
  end

  def range(cube) do
    keys = Map.keys(cube)
    [mx, my, mz, mw] = Enum.min(keys)
    [nx, ny, nz, nw] = Enum.max(keys)
    mx-1..nx+1 |> Enum.flat_map(fn x ->
      my-1..ny+1 |> Enum.flat_map(fn y ->
        mz-1..nz+1 |> Enum.flat_map(fn z ->
          mw-1..nw+1 |> Enum.map(fn w -> [x, y, z, w] end)
        end)
      end)
    end)
  end

  def step(cube) do
    range(cube)
    |> Enum.reduce(cube, fn [x, y, z, w], c ->
      current = get(cube, {x, y, z, w})
      neigh = neighbors(cube, {x, y, z, w})
      new = case current do
        "#" -> if neigh == 2 || neigh == 3, do: "#", else: "."
        "." -> if neigh == 3, do: "#", else: "."
      end
      set(c, {x, y, z, w}, new)
    end)
  end

  def p2(map) do
    final_state = 1..6 |> Enum.reduce(map, fn i, m -> step(m) end)
    final_state
    |> Map.values
    |> Enum.filter(fn
      "#" -> true
      "." -> false
    end)
    |> length
  end
end

sample3 = Aoc2020.Problem17a.load("problems/2020/17.sample")
input3 = Aoc2020.Problem17a.load("problems/2020/17.input")
AOC.runner &Aoc2020.Problem17a.p1/1, [sample3, input3]

sample4 = Aoc2020.Problem17b.load("problems/2020/17.sample")
input4 = Aoc2020.Problem17b.load("problems/2020/17.input")
AOC.runner &Aoc2020.Problem17b.p2/1, [sample4, input4]
