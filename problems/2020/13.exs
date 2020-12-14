defmodule Aoc2020.Problem13 do
  def buses(lines) do
    lines
    |> String.split(",")
    |> Enum.reject(fn x -> x == "x" end)
    |> Enum.map(&String.to_integer/1)
  end

  def next_at(ts, bus) do
    Stream.unfold(0, fn mul -> {mul + bus, mul + bus} end)
    |> Stream.drop_while(fn i -> i < ts end)
    |> Enum.take(1)
    |> hd
  end

  def p1({ts, lines}) do
    {pick, at} = buses(lines)
    |> Enum.map(fn line -> {line, next_at(ts, line)} end)
    |> Enum.min_by(&elem(&1, 1))

    (at- ts) * pick
  end
end

defmodule Aoc2020.Problem13b do
  defp buses(ids) do
    id_list = ids |> String.split(",")
    0..length(id_list)-1
    |> Enum.reduce(%{}, fn id, map ->
      case Enum.at(id_list, id) do
        "x" -> Map.put(map, :x, id)
        int -> Map.put(map, String.to_integer(int), id)
      end
    end)
    |> Map.delete(:x)
  end

  defp multiples(n) do
    Stream.unfold(0, fn next -> {n + next, n + next} end)
  end

  def p2({_, lines}) do
    first_t = lines |> String.split(",") |> Enum.at(0) |> String.to_integer
    buses = buses(lines) |> Map.delete(first_t)
    IO.inspect %{buses: buses, first_t: first_t}
    # %{first_t: first_t, buses: buses}
    multiples(first_t)

    buses |> Enum.to_list |> Enum.reduce(multiples(first_t), fn {id, mins}, stream ->
      Stream.filter(stream, fn mul -> rem(mul, id) == id - mins end)
    end)
    |> Enum.take(1)
    |> hd
  end
end

sample = {939, "7,13,x,x,59,x,31,19"}
input = {1000340,"13,x,x,x,x,x,x,37,x,x,x,x,x,401,x,x,x,x,x,x,x,x,x,x,x,x,x,17,x,x,x,x,19,x,x,x,23,x,x,x,x,x,29,x,613,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,41"}

AOC.runner &Aoc2020.Problem13.p1/1, [sample, input]
AOC.runner &Aoc2020.Problem13b.p2/1, [sample]

