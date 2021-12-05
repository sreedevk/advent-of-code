defmodule Mix.Tasks.Solve do
  use Mix.Task

  @impl Mix.Task
  def run([year, day]) do
    IO.puts "Solving Year #{year} Day #{day}"
    IO.puts("PART 1: #{Aoc.solve([year, day, 1])}")
    IO.puts("PART 2: #{Aoc.solve([year, day, 2])}")
  end

  @impl Mix.Task
  def run([year, day, part]) do
    IO.puts("PART #{part}: #{Aoc.solve([year, day, String.to_integer(part)])}")
  end

  @impl Mix.Task
  def run(args) do
    IO.puts("INVALID ARGS: #{args}")
    IO.puts("USAGE: mix solve <YY> <D> [<PART>]")
    IO.puts("EXAMPLE: mix solve 21 1 1")
    IO.puts("EXAMPLE: mix solve 21 2")
  end
end
