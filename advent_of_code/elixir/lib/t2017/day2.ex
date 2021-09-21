defmodule T2017.Day2 do
  def solve(1) do
    checksum(spreadsheet())
  end

  def solve(2) do
    divisum(spreadsheet())
  end

  defp divisum(sheet) do
    sheet
    |> Stream.map(&String.split(&1, "\t", trim: true))
    |> Enum.map(fn row -> 
      converted_row = row
                      |> Enum.map(&String.trim/1)
                      |> Enum.map(&String.to_integer/1)
      evenly_divisible_nums_quotient(converted_row)
    end)
    |> Enum.sum
  end

  def evenly_divisible_nums_quotient(nums) do
    combinations = for x <- nums, y <- nums, x != y, do: {x, y}
    combinations
    |> Enum.filter(fn {x, y} ->
      rem(x, y) == 0
    end)
    |> Enum.map(fn {x, y} -> x / y end)
    |> List.flatten
    |> Enum.sum
  end

  defp checksum(sheet) do
    sheet
    |> Stream.map(&String.split(&1, "\t", trim: true))
    |> Stream.map(fn row ->
      converted_row = row
                      |> Enum.map(&String.trim/1)
                      |> Enum.map(&String.to_integer/1)
      Enum.max(converted_row) - Enum.min(converted_row)
    end)
    |> Enum.sum()
  end

  defp spreadsheet do
    File.stream!("data/2017/day2.txt")
  end
end
