defmodule Day02 do
  def solve(1) do
    data()
    |> Enum.map(&parse_instruction/1)
  end

  def solve(2) do
    :world
  end

  defp parse_instruction(instruction) do
    case instruction do
      "U" -> [-1, 0]
      "D" -> [1, 0]
      "L" -> [0, -1]
      "R" -> [0, 1]
    end
  end

  defp data do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
  end
end
