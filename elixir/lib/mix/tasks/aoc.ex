defmodule Mix.Tasks.Aoc do
  use Mix.Task

  @impl Mix.Task
  def run(["authenticate", cookie]) do
    File.write!(".cookie", cookie)
  end

  @impl Mix.Task
  def run(["init", year, day]) do
    File.mkdir_p!("data/aoc/twenty#{year}/day#{day}/")
    HTTPoison.start()
    File.write!(
      "data/aoc/twenty#{year}/day#{day}/data.txt", 
      HTTPoison.get!("https://adventofcode.com/20#{year}/day/#{day}/input", [
        Cookie: "session=#{File.read!(".cookie")}"
      ]).body
    )

    File.mkdir_p!("lib/twenty#{year}")
    File.write!(
      "lib/twenty#{year}/day#{day}.ex", 
      String.replace(String.replace(File.read!("templates/solution.ex"), "{{year}}", year), "{{day}}", day)
    )
  end

  @impl Mix.Task
  def run(["solve", year, day]) do
    IO.puts "Solving Year #{year} Day #{day}"
    IO.puts("PART 1: #{Aoc.solve([year, day, 1])}")
    IO.puts("PART 2: #{Aoc.solve([year, day, 2])}")
  end

  @impl Mix.Task
  def run(["solve", year, day, part]) do
    IO.puts("PART #{part}: #{Aoc.solve([year, day, String.to_integer(part)])}")
  end

  @impl Mix.Task
  def run(_) do
    IO.puts("INVALID ARGS!")
    IO.puts("USAGE [AUTH]: mix aoc authenticate <cookie>")
    IO.puts("USAGE [INIT FILES]: mix aoc init <year> <day>")
    IO.puts("USAGE [SOLVE]: mix aoc solve <YY> <D> [<PART>]")
    IO.puts("EXAMPLE [SOLVE]: mix aoc solve 21 1 1")
  end
end
