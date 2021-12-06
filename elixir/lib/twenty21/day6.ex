defmodule Aoc.Twenty21.Day6 do
  def solve(1) do
    Enum.count(advance(data()))
  end

  def solve(2), do: :unsolved

  def advance(fishes, day \\ 0) do
    if day < 80 do
      fishes
      |> Enum.map(fn fish ->
        case fish do
          0 -> [6, 8]
          points -> points - 1
        end
      end)
      |> List.flatten()
      |> advance(day + 1)
    else
      fishes
    end
  end

  def data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
