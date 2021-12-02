# frozen_string_literal: true

class ReportRepair
  REQUIRED_SUM = 2020

  def data
    @data ||= ARGF.readlines.map(&:strip).map(&:to_i)
  end
  
  def part1
    data.combination(2).find { |x, y| x + y == REQUIRED_SUM }.inject(:*)
  end

  def part2
    data.combination(3).find { |x, y, z| x + y + z == REQUIRED_SUM }.inject(:*)
  end
end

solver = ReportRepair.new

puts "part I: #{solver.part1}"
puts "part II: #{solver.part2}"
