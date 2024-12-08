# frozen_string_literal: true

# Day 3 2022
class RucksackReorganization
  UPPER = Set.new('A'..'Z')

  def initialize(data)
    @data = data
            .lines
            .lazy
            .map(&:strip)
            .map(&:chars)
  end

  def solve1
    @data
      .map { _1.each_slice(_1.size / 2) }
      .map { _1.reduce(&:&).first }
      .map { _1.ord - (UPPER.member?(_1) ? 38 : 96) }
      .sum
  end

  def solve2
    @data
      .each_slice(3)
      .map { _1.reduce(&:&).first }
      .map { _1.ord - (UPPER.member?(_1) ? 38 : 96) }
      .sum
  end
end
