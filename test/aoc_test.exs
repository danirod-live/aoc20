defmodule AOCTest do
  use ExUnit.Case
  doctest AOC

  test "cartessian" do
    assert AOC.cartessian([1, 2, 3, 4]) ==
      [{1, 1}, {1, 2}, {1, 3}, {1, 4},
       {2, 1}, {2, 2}, {2, 3}, {2, 4},
       {3, 1}, {3, 2}, {3, 3}, {3, 4},
       {4, 1}, {4, 2}, {4, 3}, {4, 4}]
  end

  test "readline read lines" do
    assert AOC.readline("test/lines.txt") ==
             {:ok, ["hola", "mundo", "esto", "es", "una", "prueba"]}

    assert AOC.readline("test/lines.fake") == {:error, :enoent}
  end

  test "readmap reads maps" do
    assert AOC.readmap("test/map.txt") ==
             {:ok, [[".", "#", "."], ["_", "@", "/"], ["&", ".", ";"]]}

    assert AOC.readmap("test/map.fake") == {:error, :enoent}
  end

  test "atmap gets coordinates" do
    {:ok, map} = AOC.readmap("test/map.txt")
    assert AOC.atmap(map, 0, 0) == "."
    assert AOC.atmap(map, 1, 1) == "@"
    assert AOC.atmap(map, 2, 2) == ";"
  end

  test "fmap applies to :ok tuples" do
    doble = fn n -> 2 * n end
    assert AOC.fmap({:ok, 4}, doble) == {:ok, 8}
    assert AOC.fmap({:error, :enoent}, doble) == {:error, :enoent}
  end
end
