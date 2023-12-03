class CalorieCounting
  def initialize(data)
    @data = data
  end

  def solve1
    @data
      .strip
      .split("\n\n")
      .map { |elf| elf.split("\n").map(&:strip).map(&:to_i).sum }
      .max
  end

  def solve2
    @data
      .strip
      .split("\n\n")
      .map { |elf| elf.split("\n").map(&:strip).map(&:to_i).sum }
      .sort
      .reverse
      .take(3)
      .sum
  end
end

solver = CalorieCounting.new(ARGF.read)
pp "PART1: #{solver.solve1}"
pp "PART2: #{solver.solve2}"
