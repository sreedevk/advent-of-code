defmodule Mix.Tasks.Fetch do
  use Mix.Task

  @impl Mix.Task
  def run(["authenticate", cookie]) do
    File.write!(".cookie", cookie)
  end

  @impl Mix.Task
  def run(["problem", year, day]) do
    File.mkdir_p!("data/aoc/twenty#{year}/day#{day}/")
    HTTPoison.start()
    File.write!(
      "data/aoc/twenty#{year}/day#{day}/data.txt", 
      HTTPoison.get!("https://adventofcode.com/20#{year}/day/#{day}/input", [
        Cookie: "session=#{File.read!(".cookie")}"
      ]).body
    )
  end
end
