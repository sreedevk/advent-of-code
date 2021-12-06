class Lanternfish
  def data
    @data ||= ARGF.read.split(',').map(&:strip).map(&:to_i)
  end

  def part1
    emulate(data.tally, 80).values.sum
  end

  def part2
    emulate(data.tally, 256).values.sum
  end

  def emulate(fishes, days, day = 1)
    next_generation    = Hash.new(0)
    next_generation[8] = fishes[0].to_i
    next_generation[6] = fishes[0].to_i
    next_generation.merge!(fishes.select{ _1.positive? }.transform_keys { _1 - 1 }) { _2 + _3 }
    return next_generation if day >= days

    emulate(next_generation, days, day + 1)
  end
end

solver = Lanternfish.new
pp solver.part1
pp solver.part2
