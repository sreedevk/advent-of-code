defmodule Day02 do
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
      Map.update!(current_coordinates, :length, fn current_length -> current_length + mag end)
      |> Map.update!(:depth, fn current_depth -> current_depth + (Map.fetch!(current_coordinates, :aim) * mag)end)
      ["down", mag] -> Map.update!(current_coordinates, :aim, fn current_aim -> current_aim + mag end)
      ["up", mag] -> Map.update!(current_coordinates, :aim, fn current_aim -> current_aim - mag end)
    end
  end

  defp calculate_next_coordinates(current_coordinates, instruction) do
    case instruction do
      ["forward", mag] -> %{depth: Map.fetch!(current_coordinates, :depth), length: Map.fetch!(current_coordinates, :length) + mag}
      ["down", mag] -> %{depth: Map.fetch!(current_coordinates, :depth) + mag, length: Map.fetch!(current_coordinates, :length)}
      ["up", mag] -> %{depth: Map.fetch!(current_coordinates, :depth) - mag, length: Map.fetch!(current_coordinates, :length)}
    end
  end

  def data do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn instruction ->
      String.split(instruction, " ", trim: true)
      |> List.update_at(-1, &String.to_integer/1)
    end)
  end
end
