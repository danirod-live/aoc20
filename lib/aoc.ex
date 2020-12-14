defmodule AOC do
  def combinatory([x]), do: [[x], []]

  def combinatory([x | xs]) do
    comb = combinatory(xs)
    comb ++ Enum.map(comb, fn c -> [x | c] end)
  end

  def manhattan({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  def manhattan({x, y}), do: manhattan({0, 0}, {x, y})

  def cartessian(l) do
    l |> Enum.flat_map(fn i -> l |> Enum.map(fn j -> {i, j} end) end)
  end

  def cartessian3(l) do
    l
    |> Stream.flat_map(fn i ->
      l |> Stream.flat_map(fn j -> l |> Stream.map(fn k -> {i, j, k} end) end)
    end)
  end

  def combine(l) do
    0..(length(l) - 1)
    |> Enum.flat_map(fn i ->
      i..(length(l) - 1)
      |> Enum.map(fn j -> {Enum.at(l, i), Enum.at(l, j)} end)
    end)
  end

  def readline(path),
    do:
      File.read(path)
      |> fmap(&String.split(&1, "\n"))
      |> fmap(&Enum.filter(&1, fn line -> line != "" end))

  def readmap(path),
    do:
      File.read(path)
      |> fmap(&String.split/1)
      |> fmap(fn i -> Enum.map(i, &String.codepoints/1) end)

  def atmap(map, x, y), do: map |> Enum.at(y) |> Enum.at(x)

  def fmap({:ok, x}, f), do: {:ok, f.(x)}
  def fmap(whatever, _), do: whatever

  def runner(f, inputs) do
    helper = fn i ->
      before_t = :os.system_time(:millisecond)
      result = f.(i)
      after_t = :os.system_time(:millisecond)
      IO.inspect(result, label: "(#{after_t - before_t} ms)")
    end

    Enum.map(inputs, helper)
  end
end
