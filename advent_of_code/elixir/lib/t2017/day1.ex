defmodule T2017.Day1 do
  def solve(1) do
    converted_list = for {x, y} <- convert_graphemes(input()), do: [x, y]
    converted_list
    |> Enum.filter(fn [x, y] -> x == y end)
    |> Enum.map(&List.first/1)
    |> Enum.sum
  end

  def solve(2) do
    data = input()
    check_steps = trunc(length(data) / 2)

    data
    |> Enum.with_index()
    |> Enum.filter(fn {num, index} ->
      num == Enum.fetch!(data, rem(index + check_steps, length(data)))
    end)
    |> Enum.map(fn {num, _index} -> num end)
    |> Enum.sum()
  end

  defp convert_graphemes(datalist) do
    datalist
    |> Enum.slice(Range.new(1, -1))
    |> List.insert_at(-1, Enum.fetch!(datalist, 0))
    |> Enum.zip(datalist)
  end

  defp input do
    File.read!("data/2017/day1.txt")
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer(&1))
  end
end
