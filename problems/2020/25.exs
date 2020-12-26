defmodule Aoc2020.Problem25 do
  def transform(subject_number, loop_size) do
    1..loop_size |> Enum.reduce(1, fn _, old_val ->
      rem(old_val * subject_number, 20201227)
    end)
  end

  defp try_next_loop_size(loop_size, prev_value, public_key) do
    next_value = rem(prev_value * 7, 20201227)
    if next_value == public_key,
      do: loop_size,
      else: try_next_loop_size(loop_size + 1, next_value, public_key)
  end

  def find_secret_key(public_key), do: try_next_loop_size(1, 1, public_key)

  def p1({door_pk, card_pk}) do
    door_sk = find_secret_key(door_pk) |> IO.inspect(label: "door_sk")
    card_sk = find_secret_key(card_pk) |> IO.inspect(label: "card_sk")
    ekey_1 = transform(door_pk, card_sk) |> IO.inspect(label: "ekey_1")
    ekey_2 = transform(card_pk, door_sk) |> IO.inspect(label: "ekey_2")
    {ekey_1, ekey_2}
  end
end

AOC.runner &Aoc2020.Problem25.p1/1, [{5764801, 17807724}, {9789649, 3647239}]
