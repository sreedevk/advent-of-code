require 'pry'

class HydrothermalVenture
  attr_accessor :grid

  def initialize
    @grid = Hash.new(0)
  end

  def part1
    data
      .filter { |line| line[0].zip(line[1]).any? { _1.min == _1.max } }
      .reduce(@grid) { |grid, line|
        xs, ys = line[0].zip(line[1]).map(&:sort).map { Range.new(_1, _2) }
        xs.map { |x| ys.map {|y| grid[[x,y]] += 1 } }
        grid
      }
      .count { _2 >= 2 }
  end

  def part2
    data
      .reject { |line| line[0].zip(line[1]).any? { _1.min == _1.max } }
      .reduce(@grid) { |grid, line|
        xs, ys         = line[0].zip(line[1])
        dx, dy         = [xs, ys].map { (_2 - _1).negative? ? -1 : 1  }
        xrange, yrange = [[xs, dx], [ys, dy]].map { |ps, dp| (dp.negative? ? ps.max.step(ps.min, dp) : ps.min.step(ps.max, dp)).to_a }
        xrange.zip(yrange).map {  grid[ _1 ] += 1 }
        grid
      }
      .count { _2 >= 2}
  end

  def data
    @data ||= ARGF.readlines.map { _1.split(" -> ").map { |point| point.split(",").map(&:strip).map(&:to_i) } } 
  end
end

solver = HydrothermalVenture.new
pp solver.part1
pp solver.part2
