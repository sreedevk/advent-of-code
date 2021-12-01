defmodule Day01 do
  def solve(1) do
    data()
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn x -> length(x) > 1 end)
    |> Enum.filter(fn [x, y] -> y > x end)
    |> Enum.count
  end

  def solve(2) do
    data()
    |> Enum.chunk_every(3, 1)
    |> Enum.filter(fn x -> length(x) > 2 end)
    |> Enum.map(fn x -> Enum.sum(x) end)
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn x -> length(x) > 1 end)
    |> Enum.filter(fn [x, y] -> y > x end)
    |> Enum.count
  end

  def data do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
