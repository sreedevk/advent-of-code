defmodule Aoc.Twenty21.Day5 do
  def solve(1) do
    data()
  end

  def solve(2), do: :unsolved

  def data do
    Aoc.Utils.Data.readlines!(__MODULE__, "example.txt")
    |> Enum.map(&Regex.scan(~r/\d+/, &1, trim: true))
    |> Enum.map(&List.flatten/1)
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Enum.map(&Enum.chunk_every(&1, 2))
  end
end
