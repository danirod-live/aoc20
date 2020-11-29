fuel = fn mass -> trunc(mass / 3) - 2 end

calculate_fuel = fn masses -> Enum.map(masses, fuel) |> Enum.sum() end

{:ok, lines} = AOC.readline("problems/2019/01.input")

AOC.runner(calculate_fuel, [
  [12],
  [14],
  [1969],
  [100_756],
  lines |> Enum.map(&String.to_integer/1)
])
