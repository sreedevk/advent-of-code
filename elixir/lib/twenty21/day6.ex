defmodule Aoc.Twenty21.Day6 do
  def solve(1) do
    Enum.count(advance(data(), 80))
  end

  def solve(2) do
    Enum.count(advance(data(), 256))
  end

  def advance(fishes, days, day \\ 0) do
    if day < days do
      fishes
      |> Enum.map(&process_fish/1)
      |> List.flatten()
      |> advance(days, day + 1)
    else
      fishes
    end
  end

  defp process_fish(0), do: [6, 8]
  defp process_fish(x), do: x - 1

  def data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
