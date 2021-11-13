defmodule Mix.Tasks.Solve do
  @moduledoc "Used to run the advent of code solution"
  use Mix.Task

  @impl Mix.Task
  
  def run(_args) do
    IO.puts("\n\nAdvent Of Code. - Day06 [Part 1]")
    solve_begin = Time.utc_now()
    IO.inspect(Day06.solve(1), label: :part1)
    IO.inspect(Time.diff(Time.utc_now(), solve_begin, :millisecond), label: :solved_in)

    IO.puts("\n\nAdvent Of Code. - Day06 [Part 2]")
    solve_begin = Time.utc_now()
    IO.inspect(Day06.solve(2), label: :part2)
    IO.inspect(Time.diff(Time.utc_now(), solve_begin, :millisecond), label: :solved_in)
  end
end
