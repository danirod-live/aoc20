defmodule Aoc2020.Problem12a do
  defp init(), do: {0, 0, 0}

  defp new_state({x, y, dir}, "N" <> int), do: {x, y - String.to_integer(int), dir}
  defp new_state({x, y, dir}, "S" <> int), do: {x, y + String.to_integer(int), dir}
  defp new_state({x, y, dir}, "W" <> int), do: {x - String.to_integer(int), y, dir}
  defp new_state({x, y, dir}, "E" <> int), do: {x + String.to_integer(int), y, dir}
  defp new_state({x, y, dir}, "L" <> int), do: {x, y, dir + String.to_integer(int)}
  defp new_state({x, y, dir}, "R" <> int), do: {x, y, dir - String.to_integer(int)}

  defp new_state({x, y, dir}, "F" <> int) do
    dx = trunc(:math.cos(dir * :math.pi() / 180)) * String.to_integer(int)
    dy = trunc(:math.sin(dir * :math.pi() / 180)) * String.to_integer(int)
    {x + dx, y - dy, dir}
  end

  defp turn(s, []), do: s
  defp turn(s, [x | xs]), do: turn(new_state(s, x), xs)

  def p1(input) do
    {x, y, _} = turn(init(), input)
    AOC.manhattan({x, y})
  end
end

defmodule Aoc2020.Problem12b do
  defp init(), do: {0, 0, 10, -1}

  defp new_state({bx, by, wx, wy}, "N" <> int), do: {bx, by, wx, wy - String.to_integer(int)}
  defp new_state({bx, by, wx, wy}, "S" <> int), do: {bx, by, wx, wy + String.to_integer(int)}
  defp new_state({bx, by, wx, wy}, "W" <> int), do: {bx, by, wx - String.to_integer(int), wy}
  defp new_state({bx, by, wx, wy}, "E" <> int), do: {bx, by, wx + String.to_integer(int), wy}
  defp new_state({bx, by, wx, wy}, "R90"), do: {bx, by, -wy, wx}
  defp new_state(s, "R180"), do: s |> new_state("R90") |> new_state("R90")
  defp new_state(s, "R270"), do: s |> new_state("R180") |> new_state("R90")
  defp new_state(s, "L90"), do: new_state(s, "R270")
  defp new_state(s, "L180"), do: new_state(s, "R180")
  defp new_state(s, "L270"), do: new_state(s, "R90")

  defp new_state({bx, by, wx, wy}, "F" <> int) do
    dx = String.to_integer(int) * wx
    dy = String.to_integer(int) * wy
    {bx + dx, by + dy, wx, wy}
  end

  defp turn(s, []), do: s

  defp turn(s, [x | xs]) do
    turn(new_state(s, x), xs)
  end

  def p2(input) do
    {x, y, _, _} = turn(init(), input)
    AOC.manhattan({x, y})
  end
end

{:ok, sample} = AOC.readline("problems/2020/12.sample")
{:ok, input} = AOC.readline("problems/2020/12.input")

AOC.runner(&Aoc2020.Problem12a.p1/1, [sample, input])
AOC.runner(&Aoc2020.Problem12b.p2/1, [sample, input])
