require 'set'
require 'pry'

class Grid
  attr_accessor :memory, :sync_point

  class Point
    attr_accessor :x, :y, :state, :gridrank

    def overflow?
      @state > 9
    end

    def reset
      @state = 0
    end

    def update(value)
      @state = value
    end

    def incr
      @state += 1
    end

    def initialize(x, y, state, gridrank = 10)
      @x        = x
      @y        = y
      @state    = state
      @gridrank = gridrank
    end

    def neighbor_indices
      [
        [x + 1, y],
        [x + 1, y + 1],
        [x + 1, y - 1],
        [x - 1, y],
        [x - 1, y + 1],
        [x - 1, y - 1],
        [x, y + 1],
        [x, y - 1]
      ].select { |x1, y1| x1 >= 0 && x1 < @gridrank && y1 >= 0 && y1 < @gridrank }
    end
  end

  def [](index); @memory[index]; end
  def []=(index, value); @memory[index] = value; end

  def resolve(generations)
    generations.times.sum  do |gen|
      @memory.transform_values(&:incr)
      flash
      @memory.count { _2.state == 0 }
    end
  end

  def resolve_for_sync_point
    (0..).map do |gen|
      if @memory.values.map(&:state).all? { _1 == 0 }
        (@sync_point = gen) && break
      end

      @memory.transform_values(&:incr)
      flash
    end
    @sync_point
  end

  def print
    @memory.values.map(&:state)
  end

  def initialize(data)
    @memory = parse_grid(data)
  end

  def overflows?
    @memory.values.any?(&:overflow?)
  end

  def flash
    @memory.select { _2.overflow? && _2.state > 0 }.map do |_coordinates, point|
      point.reset
      point.neighbor_indices.filter_map do |neighbor_index|
        if self[neighbor_index].state > 0
          self[neighbor_index].incr
        end
      end
    end
    flash if overflows? 
  end

  private

  def parse_grid(data)
    data.map.with_index.inject({}) do |acc, (gridline, y)|
      acc.merge(
        gridline.strip.chars.map.with_index.inject({}) do |oacc, (octopus, x)|
          oacc.merge([x, y] => Point.new(x, y, octopus.to_i))
        end
      )
    end
  end
end

class DumboOctopus
  attr_accessor :grid
  def part1
    grid = Grid.new(data)
    grid.resolve(100)
  end

  def part2
    grid = Grid.new(data)
    grid.resolve_for_sync_point
  end

  def data
    @data ||= ARGF.readlines
  end
end

solver = DumboOctopus.new
pp solver.part1
pp solver.part2
