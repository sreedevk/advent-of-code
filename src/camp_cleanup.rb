# frozen_string_literal: true

# Advent of Code Day4
class CampCleanup
  def initialize(data)
    @data = parse(data)
  end

  def parse(input)
    input.lines.map do |line|
      line.split(',').map do |elf|
        elf
          .split('-')
          .map(&:to_i)
          .reduce(&Range.method(:new))
      end
    end
  end

  def solve1
    @data.count { |(elf1, elf2)| elf1.cover?(elf2) || elf2.cover?(elf1) }
  end

  def solve2
    @data.count { |(elf1, elf2)| elf1.cover?(elf2.first) || elf2.cover?(elf1.first) }
  end
end
