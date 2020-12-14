defmodule Aoc2020.Problem14 do
  defp parse_op("mask = " <> mask), do: {:mask, mask}
  defp parse_op("mem[" <> mem) do
    [k, v] = mem |> String.split("] = ")
    {:mem, String.to_integer(k), String.to_integer(v)}
  end

  def parse(program), do: program |> Enum.map(&parse_op/1)

  defp pad(val) do
    bits = val |> Integer.digits(2)
    zeropad = Stream.cycle([0]) |> Enum.take(36 - length(bits))
    zeropad ++ bits
  end

  defp value1(val, mask) do
    bitmask = mask |> String.codepoints
    pad(val)
    |> Enum.zip(bitmask)
    |> Enum.map(fn
      {_, "0"} -> 0
      {_, "1"} -> 1
      {b, "X"} -> b
    end)
    |> Integer.undigits(2)
  end

  def process1(program) do
    Enum.reduce(program, {%{}, ""}, fn
      {:mask, newmask}, {memory, mask} ->
        {memory, newmask}
      {:mem, k, v}, {memory, mask} ->
        {Map.put(memory, k, value1(v, mask)), mask}
    end)
  end

  def addresses(address, mask) do
    bitmask = mask |> String.codepoints
    addresses = pad(address)
    |> Enum.zip(bitmask)
    |> Enum.map(fn
      {b, "0"} -> b
      {_, "1"} -> 1
      {_, "X"} -> nil
    end)

    floating_bits = addresses
                    |> Enum.with_index
                    |> Enum.filter(fn
                      {nil, i} -> true
                      _ -> false
                    end)
                    |> Enum.map(&elem(&1, 1))

    AOC.combinatory(floating_bits)
    |> Enum.map(fn comb ->
      Enum.reduce(comb, addresses, fn b, address -> List.replace_at(address, b, 1) end)
      |> Enum.map(fn
        nil -> 0
        x -> x
      end)
    end)
    |> Enum.map(&Integer.undigits(&1, 2))
  end

  def process2(program) do
    Enum.reduce(program, {%{}, ""}, fn
      {:mask, newmask}, {memory, mask} ->
        {memory, newmask}
      {:mem, k, v}, {memory, mask} ->
        newmem = addresses(k, mask)
                 |> Enum.reduce(memory, fn addr, mem -> Map.put(mem, addr, v) end)
        {newmem, mask}
    end)
  end

  def p1(program), do: process1(parse(program)) |> elem(0) |> Map.values |> Enum.sum

  def p2(program), do: process2(parse(program)) |> elem(0) |> Map.values |> Enum.sum

end

{:ok, sample1} = AOC.readline("problems/2020/14.sample")
{:ok, sample2} = AOC.readline("problems/2020/14.sample2")
{:ok, input} = AOC.readline("problems/2020/14.input")
AOC.runner &Aoc2020.Problem14.p1/1, [sample1, input]
AOC.runner &Aoc2020.Problem14.p2/1, [sample2, input]

