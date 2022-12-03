# frozen_string_literal: true

# Day 3 2022
class RucksackReorganization
  def initialize(data)
    @data = data
            .map(&:strip)
            .map(&:chars)
  end

  def solve1
    @data
      .map { |x| x.each_slice(x.size / 2) }
      .map { |x| x.reduce(&:&).first }
      .map { |x| /[[:upper:]]/.match(x) ? (x.ord - 38) : (x.ord - 96) }
      .sum
  end

  def solve2
    @data
      .each_slice(3)
      .map { |slice| slice.reduce(&:&).first }
      .map { |x| x.ord - (/[[:upper:]]/ =~ x ? 38 : 96) }
      .sum
  end
end

solver = RucksackReorganization.new(ARGF.readlines)
puts "PART 1: #{solver.solve1}"
puts "PART 1: #{solver.solve2}"
