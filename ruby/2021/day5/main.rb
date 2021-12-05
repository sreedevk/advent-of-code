require 'pry'

class HydrothermalVenture
  attr_accessor :grid

  def part1(veins = Hash.new(0))
    veins = data
      .filter { |line| line.reduce(&:zip).any? { _1.minmax.reduce(&:eql?) } }
      .reduce(Hash.new) { |grid, line|
        grid.merge(
          line
            .reduce(&:zip)
            .map { Range.new(*_1.sort).to_a }
            .reduce(&:product)
            .reduce(Hash.new(0)) { _1.merge(Hash[_2, 1]) }
        ) { _2 + _3 }
      }

    [veins, veins.count { _2 >= 2 }]
  end

  def part2(veins = Hash.new(0))
    veins = veins.merge(
      data
        .reject { |line| line.reduce(&:zip).any? { _1.minmax.reduce(&:eql?) } }
        .reduce(veins) { |grid, line|
          grid.merge(
            line.reduce(&:zip).map { [_1, _2, (_2 - _1).negative? ? -1 : 1] }
              .map { |p1, p2, dp| (dp.negative? ? [p1, p2].max.step([p1, p2].min, dp) : [p1, p2].min.step([p1, p2].max, dp)).to_a }
              .reduce(&:zip)
              .reduce(Hash.new(0)) { _1.merge(Hash[_2, 1]) }
          ) { _2 + _3 }
        }
    )

    [veins, veins.count { _2 >= 2 }]
  end

  def solve
    veins, p1solve  = part1
    _veins, p2solve = part2(veins)
    [p1solve, p2solve]
  end

  def data
    @data ||= ARGF.readlines.map { _1.scan(/\d+/).map(&:strip).map(&:to_i).each_slice(2).to_a } 
  end
end

solver = HydrothermalVenture.new
pp solver.solve
