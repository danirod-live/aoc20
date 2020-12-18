defmodule Aoc2020.Problem18 do
  # math sums or multiplies an operation list that DOES NOT have parens
  defp do_math([x]), do: x
  defp do_math([op, :plus | next]), do: op + do_math(next)
  defp do_math([op, :times | next]), do: op * do_math(next)
  def simple_math(xs), do: xs |> Enum.reverse |> do_math

  defp handle_sums([x]), do: [x]
  defp handle_sums([op1, :plus, op2 | more]), do: handle_sums([op1 + op2 | more])
  defp handle_sums([op1, :times | more]), do: [op1, :times] ++ handle_sums(more)
  def advanced_math(xs), do: xs |> handle_sums |> simple_math

  def math(xs, :simple), do: simple_math(xs)
  def math(xs, :advanced), do: advanced_math(xs)

  # Converts a string into a tokenized list
  def clean(xs) do
    xs |> Enum.map(fn
      "(" -> :lparen
      ")" -> :rparen
      "+" -> :plus
      "*" -> :times
      x -> String.to_integer(x)
    end)
  end

  # Returns the start/end tuple position of a parentehsis block or :no if none
  def paren_pair(xs) do
    xs
    |> Enum.with_index
    |> Enum.reduce(:no, fn
      {:lparen, pos}, :no -> {pos, nil}
      _, :no -> :no
      {:lparen, pos}, {start, nil} -> {pos, nil}
      {:rparen, pos}, {start, nil} -> {start, pos}
      _, {start, nil} -> {start, nil}
      _, {start, fin} -> {start, fin}
    end)
  end

  # You reach this function if a paren block is found in xs
  def subproblem(xs, start, fin, kind) do
    antes = case start do
      0 -> []
      _ -> Enum.slice(xs, 0..start-1)
    end
    mid = Enum.slice(xs, start+1..fin-1)
    despues = Enum.slice(xs, fin+1..-1)
    antes ++ [math(mid, kind)] ++ despues
  end

  def problem(xs, kind) do
    case paren_pair(xs) do
      :no -> math(xs, kind)
      {start, pos} -> problem(subproblem(xs, start, pos, kind), kind)
    end
  end

  def p1(op, kind), do: op
  |> String.replace(" ", "")
  |> String.codepoints
  |> clean
  |> problem(kind)
end

sample = [
  "1 + 2 * 3 + 4 * 5 + 6",
  "1 + (2 * 3) + (4 * (5 + 6))",
  "2 * 3 + (4 * 5)",
  "5 + (8 * 3 + 9 + 3 * 4 * 3)",
  "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
  "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
]
{:ok, inputs} = AOC.readline("problems/2020/18.input")

IO.inspect inputs |> Enum.map(&Aoc2020.Problem18.p1(&1, :simple)) |> Enum.sum
IO.inspect inputs |> Enum.map(&Aoc2020.Problem18.p1(&1, :advanced)) |> Enum.sum
