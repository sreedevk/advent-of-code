defmodule Day10 do
  def solve(1) do
    data()
    |> adapters_list()
    |> sum_of_joltage_differences()
    |> Enum.group_by(&(&1))
    |> Map.values()
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&(&1*&2))
  end

  def solve(2), do: false

  defp sum_of_joltage_differences(adapters) do
    adapters
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [output_adapter, input_adapter] ->
      (input_adapter - output_adapter)
    end)
  end

  defp adapters_list(raw_data) do
    [Enum.sum([Enum.max(raw_data), 3]) | raw_data]
    |> Enum.sort()
  end

  defp data do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
