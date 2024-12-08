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
      .with_index
      .take_while { _1 != _1.uniq }
      .last[-1] + 5
  end

  def solve2
    @data
      .chars
      .each_cons(14)
      .with_index
      .take_while { _1 != _1.uniq }
      .last[-1] + 15
  end
end
