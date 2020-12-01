defmodule AOC do
  def cartessian(l) do
    l |> Enum.flat_map(fn i -> l |> Enum.map(fn j -> {i, j} end) end)
  end

  def cartessian3(l) do
    l
    |> Stream.flat_map(fn i ->
      l |> Stream.flat_map(fn j -> l |> Stream.map(fn k -> {i, j, k} end) end)
    end)
  end

  def readline(path), do: File.read(path) |> fmap(&String.split/1)

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
