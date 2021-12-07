defmodule Aoc.Twenty21.Day7 do
  def solve(1) do
    calc_fuel_req(data())
  end

  def solve(2) do
    calc_exponential_fuel_req(data())
  end

  def calc_fuel_req(submarines) do
    Range.new(1, Enum.max(submarines))
    |> Enum.map(fn tp ->
      submarines
      |> Enum.map(fn cp -> abs(tp - cp) end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def calc_exponential_fuel_req(submarines) do
    Range.new(1, Enum.max(submarines))
    |> Enum.map(fn tp ->
      submarines
      |> Enum.map(fn cp -> Enum.sum(Range.new(1, abs(tp - cp))) end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
