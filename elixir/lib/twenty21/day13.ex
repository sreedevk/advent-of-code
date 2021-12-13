defmodule Aoc.Twenty21.Day13 do
  require IEx;
  def solve(1) do
    MapSet.size(fold(dots(data()), List.first(folds(data()))))
  end

  def solve(2) do
    generate_folded_grid(sequential_fold(dots(data()), folds(data())))
    |> transpose()
    |> format_generated_grid()
    |> tap(&IO.puts/1)
    IO.puts("\n")
  end

  def transpose(grid) do
    grid
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def format_generated_grid(grid) do
    grid
    |> Enum.map(&List.to_string/1)
    |> Enum.join("\n")
  end

  def generate_folded_grid(folded) do
    Enum.map(Range.new(0, Enum.max(Enum.map(folded, &List.first/1))), fn x -> 
      Enum.map(Range.new(0, Enum.max(Enum.map(folded, &List.last/1))), fn y-> 
        if MapSet.member?(folded, [x, y]), do: "#", else: " "
      end)
    end)
  end

  def sequential_fold(dotsmap, foldsmap) do
    Enum.reduce(foldsmap, dotsmap, fn foldline, acc -> 
      fold(acc, foldline)
    end)
  end

  def fold(dotmap, [linex, liney]) do
    dotmap
    |> Enum.reduce(MapSet.new(), fn [x, y], acc ->
      acc
      |> MapSet.put(
        [
          (if linex == 0, do: x, else: linex - abs(linex - x)),
          (if liney == 0, do: y, else: liney - abs(liney - y))
        ]
      )
    end)
  end

  def dots(input) do
    List.first(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn coordinates ->
      Enum.map(String.split(coordinates, ",", trim: true), &String.to_integer/1)
    end)
  end

  def folds(input) do
    List.last(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn foldline -> 
      foldline
      |> String.split(" ", trim: true)
      |> List.last()
      |> String.split("=", trim: true)
    end)
    |> Enum.map(fn [axis, mag] ->
      if axis == "x", do: [String.to_integer(mag), 0], else: [0, String.to_integer(mag)]
    end)
  end

  def data do
    Aoc.Utils.Data.read!(__MODULE__)
    |> String.split("\n\n", trim: true)
  end
end
