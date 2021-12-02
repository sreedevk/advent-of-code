# frozen_string_literal: true

class PasswordPhilosophy
  def data
    @data ||= ARGF.readlines
  end

  def part1
    data
      .map { _1.match(/^(?<minim>\d+)-(?<maxim>\d+) (?<char>[a-z]): (?<password>\w+)/).named_captures }
      .count { Range.new(_1["minim"].to_i, _1["maxim"].to_i).cover?(_1["password"].count(_1["char"]))  }
  end

  def part2
    data
      .map { _1.match(/^(?<alphapos>\d+)-(?<betapos>\d+) (?<char>[a-z]): (?<password>\w+)/).named_captures }
      .count do
        _1["password"]
          .chars
          .values_at(_1["alphapos"].to_i.pred, _1["betapos"].to_i.pred)
          .compact
          .tally
          .send(:[], _1["char"])
          .eql?(1)
      end
  end
end

solver = PasswordPhilosophy.new

puts "PART I: #{solver.part1}"
puts "PART II: #{solver.part2}"
