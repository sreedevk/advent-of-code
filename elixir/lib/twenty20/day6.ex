defmodule Aoc.Twenty20.Day6 do
  def solve(1) do
    dstream()
    |> Enum.map(fn group -> 
      Enum.reduce(group, &MapSet.union/2)
    end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum
  end

  def solve(2) do
    dstream()
    |> Enum.map(fn group -> 
      Enum.reduce(group, &MapSet.intersection/2)
    end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum
  end

  defp dstream do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(fn group -> 
      Enum.map(group, fn person -> 
        MapSet.new(
          String.trim(person)
          |> String.graphemes
        )
      end)
    end)
  end
end

