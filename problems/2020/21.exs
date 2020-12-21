defmodule Aoc2020.Problem21 do
  def load(file) do
    {:ok, recipe} = File.read(file)
    parse(recipe)
  end

  def parse(recipes) do
    parsed_recipes =
      recipes
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.split("\n")
      |> Enum.filter(fn
        "" -> false
        _ -> true
      end)
      |> Enum.map(&String.split(&1, " contains "))
      |> Enum.map(fn [ings, algs] ->
        {String.split(ings, " "), String.split(algs, ", ")}
      end)

    parsed_recipes
    |> Enum.with_index()
    |> Enum.reduce(%{ingredients: %{}, alergens: %{}}, fn
      {{ings, alergs}, id}, acc ->
        new_ings =
          ings
          |> Enum.reduce(acc[:ingredients], fn ing, iacc ->
            old_list = Map.get(iacc, ing, [])
            Map.put(iacc, ing, [id | old_list])
          end)

        new_alergs =
          alergs
          |> Enum.reduce(acc[:alergens], fn alerg, iacc ->
            old_list = Map.get(iacc, alerg, [])
            Map.put(iacc, alerg, [id | old_list])
          end)

        %{ingredients: new_ings, alergens: new_alergs}
    end)
  end

  def ingredients_for_recipe(ings, id) do
    ings
    |> Map.to_list()
    |> Enum.filter(fn {_, part_of_recipes} -> id in part_of_recipes end)
    |> Enum.map(&elem(&1, 0))
  end

  def alergens_for_recipe(alergs, id) do
    alergs
    |> Map.to_list()
    |> Enum.filter(fn {_, part_of_recipes} -> id in part_of_recipes end)
    |> Enum.map(&elem(&1, 0))
  end

  def non_alergs(state) do
    Map.to_list(state[:alergens])
    |> Enum.reduce(MapSet.new(Map.keys(state[:ingredients])), fn {_, part_of_recipes},
                                                                 ingredients ->
      common_ingredients_of_recipes_of_this_alerg =
        part_of_recipes
        |> Enum.reduce(nil, fn
          id, nil ->
            ingredients_for_recipe(state[:ingredients], id) |> MapSet.new()

          id, acc ->
            here = ingredients_for_recipe(state[:ingredients], id) |> MapSet.new()
            MapSet.intersection(here, acc)
        end)

      MapSet.difference(ingredients, common_ingredients_of_recipes_of_this_alerg)
    end)
  end

  def p1(file) do
    state = load(file)

    non_alergs(state)
    |> Enum.map(fn non_alerg -> state[:ingredients][non_alerg] |> length end)
    |> Enum.sum()
  end

  defp all_ingredients(state) do
    Map.keys(state[:ingredients]) |> MapSet.new()
  end

  defp get_candidates_map(state) do
    alergens = MapSet.difference(all_ingredients(state), non_alergs(state))

    candidates_for_alergen = alergens
    |> Enum.map(fn alerg -> {alerg, state[:ingredients][alerg]} end)
    |> Enum.map(fn {alerg, part_of} ->
      {alerg, part_of |> Enum.flat_map(&alergens_for_recipe(state[:alergens], &1)) |> Enum.uniq}
    end)
    |> Enum.reduce(%{}, fn {ingredient, alergens}, map ->
      Enum.reduce(alergens, map, fn alergen, map ->
        old_list = Map.get(map, alergen, [])
        Map.put(map, alergen, [ingredient | old_list])
      end)
    end)

    all_candidates = candidates_for_alergen
    |> Map.to_list
    |> Enum.reduce([], fn {_, c}, a -> a ++ c end)
    |> Enum.uniq

    candidates_for_alergen
    #|> Map.to_list
    #|> Enum.map(fn {alerg, cands} ->
    #  {alerg, Enum.map(cands, fn c -> Enum.find_index(all_candidates, fn d -> d == c end) end)}
    #end)
    #|> Map.new
  end

  #  def p2(file) do
  #   state = load(file)
  #   candidates = get_candidates_map(state)
  #
  #   candidates
  # end
end

files = [
  "problems/2020/21.sample",
  "problems/2020/21.input",
]

AOC.runner(&Aoc2020.Problem21.p1/1, files)
