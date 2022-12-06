# frozen_string_literal: true

# Day 6 2022
class TuningTrouble
  def initialize(data)
    @data = data
  end

  def solve1
    @data
      .chars
      .each_cons(4)
      .filter_map
      .with_index { |chset, index| index + 4 if chset == chset.uniq }
      .first
  end

  def solve2
    @data
      .chars
      .each_cons(14)
      .filter_map
      .with_index { |chset, index| index + 14 if chset == chset.uniq }
      .first
  end
end

solver = TuningTrouble.new(ARGF.read)
pp "PART 1: #{solver.solve1}"
pp "PART 2: #{solver.solve2}"
