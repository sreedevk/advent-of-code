defmodule Aoc.Twenty21.Day2 do
  def solve(1) do
    data()
    |> Enum.reduce(%{depth: 0, length: 0}, fn instr, acc -> 
      calculate_next_coordinates(acc, instr)
    end)
    |> Map.values()
    |> Enum.product()
  end

  def solve(2) do
    info = data()
    |> Enum.reduce(%{depth: 0, length: 0, aim: 0}, fn instr, acc -> 
      calculate_aimed_coordinates(acc, instr)
    end)
    Map.fetch!(info, :depth) * Map.fetch!(info, :length)
  end

  defp calculate_aimed_coordinates(current_coordinates, instruction) do
    case instruction do
      ["forward", mag] ->
      Map.update!(current_coordinates, :length, &(&1 + mag))
      |> Map.update!(:depth, fn current_depth -> current_depth + (Map.fetch!(current_coordinates, :aim) * mag) end)
      ["down", mag] -> Map.update!(current_coordinates, :aim, &(&1 + mag))
      ["up", mag] -> Map.update!(current_coordinates, :aim, &(&1 - mag))
    end
  end

  defp calculate_next_coordinates(current_coordinates, instruction) do
    case instruction do
      ["forward", mag] -> Map.update!(current_coordinates, :length, &(&1 + mag))
      ["down", mag] -> Map.update!(current_coordinates, :depth, &(&1 + mag))
      ["up", mag] -> Map.update!(current_coordinates, :depth, &(&1 - mag))
    end
  end

  def data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.split("\n", trim: true)
    |> Enum.map(fn instruction ->
      String.split(instruction, " ", trim: true)
      |> List.update_at(-1, &String.to_integer/1)
    end)
  end
end
