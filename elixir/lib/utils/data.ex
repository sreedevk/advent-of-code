defmodule Aoc.Utils.Data do
  def read!(module) do
    File.read!("data/#{Macro.underscore(module)}/data.txt")
  end

  def stream!(module) do
    File.stream!("data/#{Macro.underscore(module)}/data.txt")
  end
end
