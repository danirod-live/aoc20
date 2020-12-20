gramatica = """
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"
"""

tocha = """
19: 33 53 | 123 7
3: 33 82 | 123 45
92: 47 123 | 91 33
34: 123 60 | 33 63
91: 123 9 | 33 7
20: 33 46 | 123 79
101: 33 27 | 123 56
47: 52 33 | 84 123
115: 116 33 | 7 123
41: 57 33 | 127 123
33: "a"
109: 123 89 | 33 33
106: 33 72 | 123 6
8: 42
104: 92 123 | 41 33
75: 123 22 | 33 100
21: 76 123 | 28 33
102: 95 33 | 81 123
54: 33 44 | 123 2
77: 123 13 | 33 116
1: 33 26 | 123 34
83: 123 90 | 33 66
11: 42 31
58: 9 33 | 63 123
136: 33 74 | 123 109
25: 59 123 | 52 33
17: 123 91 | 33 136
116: 89 89
32: 116 33 | 53 123
72: 9 123 | 111 33
70: 33 9
80: 33 20 | 123 1
18: 111 33 | 74 123
86: 33 122 | 123 55
14: 33 108 | 123 37
84: 33 33 | 123 123
67: 6 123 | 18 33
78: 123 58 | 33 96
38: 111 123 | 52 33
119: 125 33 | 77 123
69: 33 32 | 123 64
10: 110 123 | 3 33
118: 69 33 | 107 123
85: 123 62 | 33 17
61: 33 117 | 123 93
62: 70 123 | 117 33
4: 123 52 | 33 7
52: 123 33
40: 84 123 | 60 33
49: 123 47 | 33 65
79: 13 33 | 84 123
6: 7 33 | 116 123
113: 33 133 | 123 115
98: 116 89
53: 123 123
42: 33 35 | 123 21
44: 33 15 | 123 55
100: 123 67 | 33 121
27: 88 33 | 9 123
76: 33 23 | 123 85
16: 33 24 | 123 73
9: 123 33 | 33 123
26: 109 123 | 59 33
36: 7 33 | 52 123
50: 123 88 | 33 63
65: 59 33 | 84 123
105: 9 123 | 7 33
112: 74 33 | 60 123
120: 111 123 | 84 33
23: 106 33 | 126 123
110: 104 123 | 102 33
128: 33 12 | 123 5
31: 123 114 | 33 10
30: 57 123 | 98 33
82: 33 51 | 123 128
125: 7 123 | 9 33
99: 123 120 | 33 93
87: 52 123 | 59 33
37: 33 101 | 123 16
43: 123 7 | 33 88
117: 123 63 | 33 7
12: 33 88 | 123 53
55: 33 111
2: 123 132 | 33 38
96: 33 116 | 123 7
135: 33 109 | 123 111
126: 112 123 | 36 33
97: 111 33 | 60 123
22: 33 113 | 123 48
24: 74 33 | 84 123
130: 91 33 | 103 123
132: 33 109 | 123 53
59: 33 89 | 123 123
51: 123 40 | 33 50
28: 54 123 | 68 33
66: 33 111 | 123 52
64: 13 33 | 9 123
15: 33 13 | 123 111
114: 14 123 | 75 33
35: 123 131 | 33 39
90: 60 123 | 52 33
124: 33 32 | 123 71
63: 123 123 | 33 123
121: 33 97 | 123 19
71: 116 123 | 53 33
5: 33 53 | 123 63
111: 33 33 | 123 33
74: 33 123 | 33 33
48: 94 123 | 105 33
56: 111 33 | 84 123
29: 30 33 | 130 123
45: 99 123 | 119 33
93: 52 33 | 52 123
122: 33 9 | 123 7
103: 13 33 | 63 123
68: 61 33 | 49 123
94: 33 88 | 123 129
129: 89 33 | 33 123
133: 123 59 | 33 129
127: 33 74 | 123 59
0: 8 11
134: 78 123 | 83 33
73: 111 33 | 116 123
89: 33 | 123
123: "b"
131: 80 123 | 134 33
81: 123 43 | 33 56
7: 123 33 | 123 123
13: 123 33 | 89 123
60: 33 33
108: 124 123 | 86 33
39: 123 29 | 33 118
95: 123 87 | 33 135
88: 33 123
57: 123 60 | 33 9
107: 123 4 | 33 25
46: 123 60 | 33 7
"""

defmodule Aoc2020.Problem19a do
  defp parse_rule(rule) do
    case rule do
      "a" -> :a
      "b" -> :b
      _ -> String.split(rule, " | ") |> Enum.map(fn combination ->
             String.split(combination, " ") |> Enum.map(&String.to_integer/1)
           end)
    end
  end

  def rules_map(rules) do
    rules
    |> String.replace("\"", "")
    |> String.split("\n")
    |> Enum.filter(fn "" -> false; _ -> true end)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [num, val] -> {String.to_integer(num), parse_rule(val)} end)
    |> Map.new
  end

  defp combine(combinations, append) when is_binary(append) do
    case combinations do
      [] -> [append]
      _ -> combinations |> Enum.map(fn combo -> combo <> append end)
    end
  end

  defp combine(combinations, append) when is_list(append) do
    case combinations do
      [] -> append
      _ -> Enum.flat_map(combinations, fn combo ->
        Enum.map(append, fn a -> combo <> a end)
      end)
    end
  end

  def unroll_rule(map, rule) do
    Enum.reduce(rule, [], fn i, combos ->
      combine(combos, unroll(map, map[i]))
    end)
  end

  def unroll(_map, :a), do: "a"

  def unroll(_map, :b), do: "b"

  def unroll(map, list_of_rules) do
    Enum.flat_map(list_of_rules, &unroll_rule(map, &1))
  end

  def combinations(map, n), do: unroll(map, map[n])

  def p1(input_file) do
    %{rules: rules, messages: messages} = read_file(input_file)
    valid_rules = combinations(rules, 0) |> MapSet.new
    messages
    |> Enum.filter(fn message -> MapSet.member?(valid_rules, message) end)
    |> length
  end

  def read_file(file) do
    {:ok, content} = File.read(file)
    [rules, message] = String.split(content, "\n\n")
    %{
      rules: rules |> rules_map,
      messages: message |> String.split("\n")
    }
  end
end

AOC.runner &Aoc2020.Problem19a.p1/1, [
  "problems/2020/19.sample",
  "problems/2020/19.input",
]
