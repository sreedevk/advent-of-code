defmodule Aoc do
  def solve([year, day, part]) do
    apply(:"Elixir.Aoc.Twenty#{year}.Day#{day}", :solve, [part])
  end
end
