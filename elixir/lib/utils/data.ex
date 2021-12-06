defmodule Aoc.Utils.Data do
  def read!(module, filename \\ "data.txt") do
    File.read!("data/#{Macro.underscore(module)}/#{filename}")
  end

  def readlines!(module, filename \\ "data.txt") do
    File.read!("data/#{Macro.underscore(module)}/#{filename}")
    |> String.split("\n", trim: true)
  end

  def stream!(module, filename \\ "data.txt") do
    File.stream!("data/#{Macro.underscore(module)}/#{filename}")
  end

  def streambytes!(module, filename \\ "data.txt") do
    File.stream!("data/#{Macro.underscore(module)}/#{filename}", [], 1)
  end
end
