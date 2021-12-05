defmodule Aoc.Twenty21.Day3 do
  def solve(1) do
    Enum.reduce([gamma_rate(data()), epsilon_rate(data())], &(&1 * &2))
  end

  def solve(2), do: "Solved in Ruby"

  defp gamma_rate(dataset) do
    Range.new(0, length(Enum.fetch!(dataset, 0)) - 1)
    |> Enum.map(fn position -> Enum.map(dataset, &Enum.fetch!(&1, position)) end)
    |> Enum.map(fn position_set -> Enum.frequencies(position_set) end)
    |> Enum.map(fn position_freq ->
      Enum.max_by(Enum.to_list(position_freq), fn freq_list -> List.last(Tuple.to_list(freq_list)) end)
    end)
    |> Enum.map(fn { max_digit, _ } -> max_digit end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp epsilon_rate(dataset) do
    Range.new(0, length(Enum.fetch!(dataset, 0)) - 1)
    |> Enum.map(fn position -> Enum.map(dataset, &Enum.fetch!(&1, position)) end)
    |> Enum.map(fn position_set -> Enum.frequencies(position_set) end)
    |> Enum.map(fn position_freq ->
      Enum.min_by(Enum.to_list(position_freq), fn freq_list -> List.last(Tuple.to_list(freq_list)) end)
    end)
    |> Enum.map(fn { max_digit, _ } -> max_digit end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn number -> Enum.map(number, &String.to_integer/1) end)
  end
end
