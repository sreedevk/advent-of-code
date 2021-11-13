defmodule Mix.Tasks.Solve do
  @moduledoc "Used to run the advent of code solution"
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    IO.puts("Advent Of Code.")
    IO.puts("PART I: #{Day01.solve(1)}")
    IO.puts("PART II: #{Day01.solve(2)}")
  end
end
