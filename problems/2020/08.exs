defmodule Aoc2020.Problem08 do
  def load(input) do
    input
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [a, b] -> {String.to_atom(a), String.to_integer(b)} end)
  end

  def init_state(), do: %{acc: 0, ip: 0}

  def next_state(prog, state) do
    {opcode, param} = Enum.at(prog, state[:ip])

    case opcode do
      :acc -> %{state | ip: state[:ip] + 1, acc: state[:acc] + param}
      :jmp -> %{state | ip: state[:ip] + param}
      :nop -> %{state | ip: state[:ip] + 1}
    end
  end

  defp run1(prog, state, history) do
    if MapSet.member?(history, state[:ip]) do
      state[:acc]
    else
      new_state = next_state(prog, state)
      run1(prog, new_state, MapSet.put(history, state[:ip]))
    end
  end

  defp run2(prog, state, history) do
    cond do
      MapSet.member?(history, state[:ip]) ->
        {false, nil}

      state[:ip] == length(prog) ->
        {true, state[:acc]}

      true ->
        new_state = next_state(prog, state)
        run2(prog, new_state, MapSet.put(history, state[:ip]))
    end
  end

  defp mutate(prog, at) do
    {opcode, param} = Enum.at(prog, at)

    new_opcode =
      case opcode do
        :acc -> :acc
        :nop -> :jmp
        :jmp -> :nop
      end

    List.replace_at(prog, at, {new_opcode, param})
  end

  def run1(prog), do: run1(load(prog), init_state(), MapSet.new())

  def run2(prog) do
    bootcode = load(prog)

    solution =
      0..length(prog)
      |> Stream.map(fn t -> {t, run2(mutate(bootcode, t), init_state(), MapSet.new())} end)
      |> Stream.filter(fn {id, {outcome, _}} -> outcome end)
      |> Stream.take(1)
      |> Enum.into([])
      |> hd
      |> elem(0)

    run2(mutate(bootcode, solution), init_state(), MapSet.new())
  end
end

{:ok, sample} = AOC.readline("problems/2020/08.sample")
{:ok, real} = AOC.readline("problems/2020/08.input")

AOC.runner(&Aoc2020.Problem08.run1/1, [sample, real])
AOC.runner(&Aoc2020.Problem08.run2/1, [sample, real])
