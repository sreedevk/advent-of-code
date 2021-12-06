defmodule Aoc.Twenty21.Day6 do
  def solve(1) do
    Enum.sum(Map.values(emulate(Enum.frequencies(data()), 80)))
  end

  def solve(2) do
    Enum.sum(Map.values(emulate(Enum.frequencies(data()), 256)))
  end

  def emulate(fishes, days, day \\ 1) do
    if day >= days, do: next_gen(fishes), else: emulate(next_gen(fishes), days, day + 1)
  end

  def next_gen(fishes) do
       Map.merge(
         %{ 6 => Map.get(fishes, 0, 0), 8 => Map.get(fishes, 0, 0) },
         Map.new(
           Enum.filter(fishes, fn {k, _v} -> k > 0 end),
           fn {fp, count} -> {fp - 1, count} end), fn _k, v1, v2 -> v1 + v2 end
       )
  end

  def data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
